//
//  GetExpriencesService.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import Foundation
import Combine

class GetHomeDataService {
    
    @Published var allExpriences: [ExperienceModel] = []
    @Published var recentExpriences: [ExperienceModel] = []
    @Published var experirencDetails: ExperienceModel? = nil
    var cancelleabels = Set<AnyCancellable>()

    var expriencesSubscription: AnyCancellable?
    var recentexpriencesSubscription: AnyCancellable?
    var filteredExperiencesSubscription: AnyCancellable?
    var likeExperienceCancellable: AnyCancellable?
    private let allCacheKey = "allExperiencesCache"
    private let recentCacheKey = "recentExperiencesCache"

    init()  {
        loadCache()
        getHomedata()
      
    }
    
    func getExpriences() async {
        
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences?filter[recommended]=true") else { return }

        expriencesSubscription = NetworkingManager.download(url: url)
            .decode(type: HomeResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedExprences) in
                self?.allExpriences = returnedExprences.data ?? []
                self?.expriencesSubscription?.cancel()
            })
    }
    
    func getRcentExpriences() async {
        
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences") else { return }

        recentexpriencesSubscription = NetworkingManager.download(url: url)
            .decode(type: HomeResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedExprences) in
                self?.recentExpriences = returnedExprences.data ?? []
                self?.recentexpriencesSubscription?.cancel()
                self?.saveCache()
            })
    }
    
    func getExpericesWithSearchText(_ searchText: String) async {
        
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences?filter[title]=\((searchText))") else { return }

        filteredExperiencesSubscription = NetworkingManager.download(url: url)
            .decode(type: HomeResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedExprences) in
                self?.recentExpriences = returnedExprences.data ?? []
                self?.filteredExperiencesSubscription?.cancel()
                self?.saveCache()
            })
        
    }
    
    @MainActor
    func likeExperience(_ id: String) async -> Bool {
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences/\(id)/like") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return await withCheckedContinuation { continuation in
            NetworkingManager.download(request: request)
                .sink(receiveCompletion: { completion in
                    NetworkingManager.handleCompletion(completion: completion)
                    
                    if case .failure(_) = completion {
                        continuation.resume(returning: false)
                    }
                }, receiveValue: { _ in
                    continuation.resume(returning: true)
                })
                .store(in: &cancelleabels)
        }
    }
    
    func addHomeServiceTotaskGroup() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.getExpriences() }
            group.addTask { await self.getRcentExpriences()}
           
          }
    }
    
    private func getHomedata() {
        Task {
            await addHomeServiceTotaskGroup()
        }
    }
    
    private func loadCache() {
            if let allData = UserDefaults.standard.data(forKey: allCacheKey),
               let allCached = try? JSONDecoder().decode([ExperienceModel].self, from: allData) {
                allExpriences = allCached
            }
            if let recentData = UserDefaults.standard.data(forKey: recentCacheKey),
               let recentCached = try? JSONDecoder().decode([ExperienceModel].self, from: recentData) {
                recentExpriences = recentCached
            }
        }
    
    private func saveCache() {
        if let allData = try? JSONEncoder().encode(allExpriences) {
            UserDefaults.standard.set(allData, forKey: allCacheKey)
        }
        if let recentData = try? JSONEncoder().encode(recentExpriences) {
            UserDefaults.standard.set(recentData, forKey: recentCacheKey)
        }
    }
    
}
