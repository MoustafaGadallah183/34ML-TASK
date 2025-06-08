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
    @Published var isLoading: Bool = false
    
    private var detailsSubscription: AnyCancellable?
    
    func getExperiencesDetails(experience: ExperienceModel?) {
        guard let experience = experience,
              let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences/\(experience.id ?? "")") else {
            return
        }
        
        isLoading = true
        
        detailsSubscription = NetworkingManager.download(url: url)
            .decode(type: ExperienceDetailsResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
              
            }, receiveValue: { [weak self] response in
                self?.details = response.data
                self?.detailsSubscription?.cancel()
            })
    }
    
    
}
