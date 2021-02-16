//
//  Cache.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import RealmSwift
import Foundation

class Favorite: Object, Identifiable {
	@objc dynamic var id: String = ""
	@objc dynamic var url: String = ""
	@objc dynamic var deleted: Bool = false
	@objc dynamic var createdAt: Date = Date()
	
	override class func primaryKey() -> String? {
		"id"
	}
}
