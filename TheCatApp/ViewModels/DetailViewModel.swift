//
//  DetailViewModel.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import Combine
import SwiftUI

class DetailViewModel: ObservableObject {
	
	private var realmManager: RealmManager = RealmManager.shared
	
	let id: String
	let url: String
	
	init(id: String, url: String) {
		self.id	= id
		self.url = url
	}
	
	func validate() -> Bool {
		realmManager.get(Favorite.self, by: "id = '\(id)' AND deleted = false").first != nil
	}
	
	func addToFavorites() {
		let favorite = Favorite()
		favorite.id = id
		favorite.url = url
		favorite.deleted = false
		realmManager.set(favorite)
	}
	
	func removeFromFavorites() {
		let favorite = Favorite()
		favorite.id = id
		favorite.url = url
		favorite.deleted = true
		realmManager.set(favorite)
	}
	
	func handleFavorite() {
		if validate() {
			removeFromFavorites()
		} else {
			addToFavorites()
		}
		
		NotificationCenter.default.post(name: .updateFavorites, object: nil)
	}
	
}
