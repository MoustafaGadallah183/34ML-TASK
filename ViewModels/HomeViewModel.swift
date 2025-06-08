//
//  HomeViewModel.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var recommendedExpeirneces: [ExperienceModel] = []
    @Published var mostRecentExpeirneces: [ExperienceModel] = []
    @Published var selectedExperimentModel: ExperienceModel?
    @Published var showDetail =  false
    @Published var searchText: String = ""
    
    private let homeDataService = GetHomeDataService()
    var cancelleabels = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        $searchText.combineLatest( homeDataService.$recentExpriences)
            .map(filterExperiences)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
               .sink { [weak self] retrurnedCoins in
                self?.mostRecentExpeirneces = retrurnedCoins
            }.store(in: &cancelleabels)
   
        homeDataService.$allExpriences
            .sink { [weak self] (recommendedExpeirneces) in
                self?.recommendedExpeirneces = recommendedExpeirneces
               
            }
            .store(in: &cancelleabels)
        
        homeDataService.$recentExpriences
            .sink { [weak self] (recommendedExpeirneces) in
                self?.mostRecentExpeirneces = recommendedExpeirneces
               
            }
            .store(in: &cancelleabels)
        
        
    }
    
    
    private func filterExperiences(searchText: String , coins: [ExperienceModel]) -> [ExperienceModel] {
        
        guard !searchText.isEmpty else  {
            return coins
        }
        
        let lowercasedSearchText = searchText.lowercased()
        return coins.filter {
            $0.detailedDescription?.lowercased().contains(lowercasedSearchText) ?? false
        }
    
    
    }

}
