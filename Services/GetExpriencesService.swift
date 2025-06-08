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

    var expriencesSubscription: AnyCancellable?
    var recentexpriencesSubscription: AnyCancellable?
    var detailsSubscription: AnyCancellable?


    init()  {
       
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
            })
    }
    
    
    func getExpriencesDetails(experience:ExperienceModel?) async {
        
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences/\(experience?.id ?? "")") else { return }

        detailsSubscription = NetworkingManager.download(url: url)
            .decode(type: ExperienceDetailsResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedExprences) in
                self?.experirencDetails = returnedExprences.data
                self?.detailsSubscription?.cancel()
            })
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
    
}
