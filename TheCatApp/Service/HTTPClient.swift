//
//  HTTPClient.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation

typealias HTTPBody = [String: AnyObject]

enum APIError: Error {
	case unknown
	case serialization
	case forbidden
	case notFound
}

enum ContentType: String {
	case json = "application/json"
	case urlEncoded = "application/x-www-form-urlencoded"
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

final class HTTPClient {
	
	private let urlSession: URLSession
	private let apiKey: String
	private let url: String
	
	init(urlSession: URLSession = .shared,
		 url: String = "https://api.thecatapi.com/v1",
		 apiKey: String = "84d265f3-532e-44cc-846e-46890316e160") {
		self.urlSession = urlSession
		self.url = url
		self.apiKey = apiKey
	}
}

extension HTTPClient {
	
	private func fetch<E: Codable>(path: String,
								   type: E.Type,
								   body: HTTPBody? = nil,
								   method: HTTPMethod = .get,
								   contentType: ContentType = .json,
								   completion: @escaping (Result<E, APIError>) -> Void) {
		
		let requestUrl = URL(string: url.appending(path))!
		var request = URLRequest(url: requestUrl)
		request.httpMethod = method.rawValue
		request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
		request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
		
		if method == .post || method == .put, let body = body {
			if contentType == .json {
				do {
					let httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
					request.httpBody = httpBody
				} catch {
					completion(.failure(.serialization))
					return
				}
			} else if contentType == .urlEncoded {
				let query = body.map { "\($0)=\($1)" }.joined(separator: "&")
				request.httpBody = query.data(using: .utf8)
			}
		}
		
		let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
			
			if let response = response as? HTTPURLResponse {
				
				switch response.statusCode {
				case 200..<300:
					
					#if DEBUG
					print("🔥 API: \(path)")
					#endif
					
					guard let data = data else {
						completion(.failure(.unknown))
						return
					}
					
					do {
						let decodedResponse = try JSONDecoder().decode(type, from: data)
						completion(.success(decodedResponse))
					} catch {
						completion(.failure(.serialization))
					}
					
				case 400, 404:
					if let data = data {
						do {
							let decodedResponse = try JSONDecoder().decode(type, from: data)
							completion(.success(decodedResponse))
						} catch {
							completion(.failure(.notFound))
						}
					} else {
						completion(.failure(.notFound))
					}
					
				case 401..<403:
					completion(.failure(.forbidden))
					
				default:
					completion(.failure(.unknown))
				}
			}
			
			if let error = error {
				print(error)
				completion(.failure(.unknown))
			}
		})
		
		task.resume()
	}
	
	func get<E: Codable>(path: String, type: E.Type, completion: @escaping (Result<E, APIError>) -> Void) {
		fetch(path: path, type: type, method: .get, completion: completion)
	}

}
