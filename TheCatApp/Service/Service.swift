//
//  Service.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation

final class Service {
	
	let client: HTTPClient
	
	init(client: HTTPClient = HTTPClient()) {
		self.client = client
	}
	
	func getCats(page: Int = 1, completion: @escaping (Result<[CatImage], APIError>) -> Void) {
		client.get(path: "/images/search?limit=\(kPageSize)&page=\(page)", type: [CatImage].self, completion: completion)
	}
}
