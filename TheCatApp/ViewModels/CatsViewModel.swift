//
//  CatsViewModel.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import Combine

class CatsViewModel: ObservableObject {
	
	@Published private(set) var state = State()
	
	private var service: Service = Service()
	
	func fetchNextPage() {
		guard state.canLoadNextPage else { return }
		
		service.getCats(page: state.page, completion: { [weak self] result in
			switch result {
			case let .success(images):
				DispatchQueue.main.async {
					self?.state.images += images
					self?.state.page += 1
					self?.state.canLoadNextPage = images.count == kPageSize
				}
			case let .failure(error):
				print("service error: ", error)
			}
		})
	}
	
	struct State {
		var images: [CatImage] = []
		var page: Int = 1
		var canLoadNextPage = true
	}
}
