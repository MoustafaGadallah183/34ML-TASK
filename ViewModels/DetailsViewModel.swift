//
//  DetailsViewModel.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//
import Combine
import Foundation

class HomeDetailsViewModel: ObservableObject {
    
    
    @Published var details: ExperienceModel?
    private var homeDataService = GetHomeDataService()
    var cancelleabels = Set<AnyCancellable>()
    var detailsSubscription: AnyCancellable?


    func getExpriencesDetails(experience:ExperienceModel?) async {
        
        guard let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences/\(experience?.id ?? "")") else { return }

         detailsSubscription = NetworkingManager.download(url: url)
            .decode(type: ExperienceDetailsResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedExprences) in
                self?.details = returnedExprences.data
                self?.detailsSubscription?.cancel()
            })
    }
    
 
    
}
