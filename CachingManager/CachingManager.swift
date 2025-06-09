//
//  CachingManager.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import Foundation

class ExperienceCacheManager {
    
    private let recommendedKey = "cachedRecommendedExperiences"
    private let recentKey = "cachedRecentExperiences"

    static let shared = ExperienceCacheManager()
    private let defaults = UserDefaults.standard

    private init() {}

    func saveRecommended(_ experiences: [ExperienceModel]) {
        save(experiences, forKey: recommendedKey)
    }

    func saveRecent(_ experiences: [ExperienceModel]) {
        save(experiences, forKey: recentKey)
    }

    func getRecommended() -> [ExperienceModel] {
        get(forKey: recommendedKey)
    }

    func getRecent() -> [ExperienceModel] {
        get(forKey: recentKey)
    }

    private func save(_ experiences: [ExperienceModel], forKey key: String) {
        do {
            let data = try JSONEncoder().encode(experiences)
            defaults.set(data, forKey: key)
        } catch {
            print("❌ Failed to save experiences: \(error.localizedDescription)")
        }
    }

    private func get(forKey key: String) -> [ExperienceModel] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([ExperienceModel].self, from: data)
        } catch {
            print("❌ Failed to decode experiences: \(error.localizedDescription)")
            return []
        }
    }

    func clearAll() {
        defaults.removeObject(forKey: recommendedKey)
        defaults.removeObject(forKey: recentKey)
    }
}
