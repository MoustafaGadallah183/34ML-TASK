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
              let id = experience.id,
              let url = URL(string: "https://aroundegypt.34ml.com/api/v2/experiences/\(id)") else {
            return
        }
        
       loadCachedDetail(for: id)
        isLoading = true
        
        detailsSubscription = NetworkingManager.download(url: url)
            .decode(type: ExperienceDetailsResponse.self, decoder: JSONDecoder().with(decodingStrategy: .convertFromSnakeCase))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.details = response.data
                self?.saveDetail(for: id)
                self?.detailsSubscription?.cancel()
            })
    }
    
    private func cacheKey(for id: String) -> String {
        return "cachedExperienceDetail_\(id)"
    }
    
    private func saveDetail(for id: String) {
        guard let detail = details else {
            UserDefaults.standard.removeObject(forKey: cacheKey(for: id))
            return
        }
        if let encoded = try? JSONEncoder().encode(detail) {
            UserDefaults.standard.set(encoded, forKey: cacheKey(for: id))
        }
    }
    
    private func loadCachedDetail(for id: String) {
        let key = cacheKey(for: id)
        if let data = UserDefaults.standard.data(forKey: key),
           let decodedDetail = try? JSONDecoder().decode(ExperienceModel.self, from: data) {
            details = decodedDetail
        }
    }
}

