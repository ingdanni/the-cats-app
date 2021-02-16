//
//  RealmManager.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import RealmSwift

final class RealmManager {
	
	static let shared = RealmManager()
	
	private var realm: Realm {
		do {
			let realm = try Realm()
			return realm
		} catch {
			print("Could not access database: \(error.localizedDescription)")
		}
		
		return self.realm
	}
	
	func getRealmRouteFile() {
		print("REALM FILE: \(String(describing: realm.configuration.fileURL))")
	}
	
	func setCollection<T: Object>(_ objects: [T]) {
		do {
			try realm.write {
				realm.add(objects)
			}
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
		}
	}
	
	func updateCollection<T: Object>(_ objects: [T]) {
		do {
			try realm.write {
				realm.add(objects, update: .modified)
			}
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
		}
	}
	
	func set<T: Object>(_ object: T) {
		do {
			try realm.write {
				realm.add(object, update: .modified)
			}
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
		}
	}
	
	func update(updates: @escaping () -> Void) {
		do {
			try realm.write {
				updates()
			}
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
		}
	}
	
	func get<T: Object>(_ type: T.Type, by filter: String = "", sortBy: String = "", sortAscending: Bool = true) -> [T] {
		let results: Results<T>
		
		if filter.isEmpty {
			if !sortBy.isEmpty {
				results = realm.objects(T.self).sorted(byKeyPath: sortBy, ascending: sortAscending)
			} else {
				results = realm.objects(T.self)
			}
		} else {
			if !sortBy.isEmpty {
				results = realm.objects(T.self).filter(filter).sorted(byKeyPath: sortBy, ascending: sortAscending)
			} else {
				results = realm.objects(T.self).filter(filter)
			}
		}
		
		return Array(results)
	}
	
	func delete(object: Object) {
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
		}
	}
	
	@discardableResult func deleteAll<T: Object>(of type: T.Type, by filter: String = "") -> Bool {
		let results: Results<T>
		if filter.isEmpty {
			results = realm.objects(T.self)
		} else {
			results = realm.objects(T.self).filter(filter)
		}
		
		guard !results.isEmpty else { return false }
		
		do {
			try realm.write {
				realm.delete(results)
			}
			
			return true
		} catch {
			print("Could not write to database: \(error.localizedDescription)")
			return false
		}
	}
	
}

