//
//  LocalDataUpload.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import Foundation

class PendingLikesManager {
    static let shared = PendingLikesManager()
    
    private let key = "PendingLikesIDs"
    private var pendingLikes: Set<String> = []
    
    private init() {
        load()
    }
    
    private func load() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            pendingLikes = Set(saved)
        }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(pendingLikes), forKey: key)
    }
    
    func add(_ id: String) {
        pendingLikes.insert(id)
        save()
    }
    
    func remove(_ id: String) {
        pendingLikes.remove(id)
        save()
    }
    
    func all() -> [String] {
        Array(pendingLikes)
    }
}
