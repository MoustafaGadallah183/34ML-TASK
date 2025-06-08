//
//  HomeViewModel.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import Foundation
import Combine

import Foundation
import Combine
import Network

class HomeViewModel: ObservableObject {
    
    @Published var recommendedExpeirneces: [ExperienceModel] = []
    @Published var mostRecentExpeirneces: [ExperienceModel] = []
    @Published var selectedExperimentModel: ExperienceModel?
    @Published var showDetail = false
    @Published var searchText: String = ""
    
    let homeDataService = GetHomeDataService()
    var cancelleabels = Set<AnyCancellable>()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        loadCachedExperiences()
        addSubscribers()
        fetchData()
        startNetworkMonitoring()
    }
    
    func addSubscribers() {
        homeDataService.$allExpriences
            .sink { [weak self] (recommendedExpeirneces) in
                self?.recommendedExpeirneces = recommendedExpeirneces
                ExperienceCacheManager.shared.saveRecommended(recommendedExpeirneces)
            }
            .store(in: &cancelleabels)
        
        homeDataService.$recentExpriences
            .sink { [weak self] (recentExperiences) in
                self?.mostRecentExpeirneces = recentExperiences
                ExperienceCacheManager.shared.saveRecent(recentExperiences)
            }
            .store(in: &cancelleabels)
        
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.performSearch()
            }
            .store(in: &cancelleabels)
    }
    
    func performSearch() {
        Task {
            await homeDataService.getExpericesWithSearchText(searchText)
        }
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                Task {
                    await self?.syncPendingLikes()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    @MainActor
    func likeExperience(_ id: String) async -> Int? {
        func updateLikes(in array: inout [ExperienceModel]) {
            if let index = array.firstIndex(where: { $0.id == id }) {
                array[index].likesNo? += 1
            }
        }
        updateLikes(in: &mostRecentExpeirneces)
        updateLikes(in: &recommendedExpeirneces)
        if let currentLikes = selectedExperimentModel?.likesNo, selectedExperimentModel?.id == id {
            selectedExperimentModel?.likesNo = currentLikes + 1
        }
        
        ExperienceCacheManager.shared.saveRecommended(recommendedExpeirneces)
        ExperienceCacheManager.shared.saveRecent(mostRecentExpeirneces)
        
        if monitor.currentPath.status != .satisfied {
            PendingLikesManager.shared.add(id)
            return selectedExperimentModel?.likesNo ??
                   mostRecentExpeirneces.first(where: { $0.id == id })?.likesNo ??
                   recommendedExpeirneces.first(where: { $0.id == id })?.likesNo
        }
        
        let success = await homeDataService.likeExperience(id)
        if !success {
            PendingLikesManager.shared.add(id)
        } else {
            PendingLikesManager.shared.remove(id)
        }
        
        return selectedExperimentModel?.likesNo ??
               mostRecentExpeirneces.first(where: { $0.id == id })?.likesNo ??
               recommendedExpeirneces.first(where: { $0.id == id })?.likesNo
    }
    
    @MainActor
    func syncPendingLikes() async {
        let pending = PendingLikesManager.shared.all()
        guard !pending.isEmpty else { return }
        
        for id in pending {
            let success = await homeDataService.likeExperience(id)
            if success {
                PendingLikesManager.shared.remove(id)
            }
        }
    }
    
    func loadCachedExperiences() {
        recommendedExpeirneces = ExperienceCacheManager.shared.getRecommended()
        mostRecentExpeirneces = ExperienceCacheManager.shared.getRecent()
    }
    
    func fetchData() {
        Task {
            await homeDataService.getExpriences()
            await homeDataService.getRcentExpriences()
        }
    }
    
    func updateLocalLikeCount(for id: String, likes: Int) {
        if let index = recommendedExpeirneces.firstIndex(where: { $0.id == id }) {
            recommendedExpeirneces[index].likesNo = likes
        }
        if let index = mostRecentExpeirneces.firstIndex(where: { $0.id == id }) {
            mostRecentExpeirneces[index].likesNo = likes
        }
        
      
        if selectedExperimentModel?.id == id {
            selectedExperimentModel?.likesNo = likes
        }
        
        ExperienceCacheManager.shared.saveRecommended(recommendedExpeirneces)
        ExperienceCacheManager.shared.saveRecent(mostRecentExpeirneces)
    }
}
