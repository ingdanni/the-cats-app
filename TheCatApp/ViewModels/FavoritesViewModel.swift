//
//  FavoritesViewModel.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
	
	@Published private(set) var images: [Favorite] = []
	
	private var realmManager: RealmManager = RealmManager.shared
	
	func fetchImages() {
		self.images = self.realmManager.get(Favorite.self, by: "deleted = false")
	}
	
}
