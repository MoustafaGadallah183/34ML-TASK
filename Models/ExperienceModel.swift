//
//  ExperienceModel.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//




import Foundation

// MARK: - ExperienceModel
struct ExperienceModel: Codable ,Identifiable , Equatable {
   
    var id, title: String?
    var coverPhoto: String?
    var description: String?
    var viewsNo, likesNo, recommended, hasVideo: Int?
    var tourHTML: String?
    var famousFigure: String?
    var founded, detailedDescription, address: String?
    var startingPrice: Int?
    var ticketPrices: [TicketPrice]?
    var isLiked: Bool?
    var rating, reviewsNo: Int?
    var audioURL: String?
    var hasAudio: Bool?
    var city : City?
    
    
}

// MARK: - TicketPrice
struct TicketPrice: Codable , Equatable {
    var type: String?
    var price: Int?
}

struct City: Codable , Equatable {
    var id: Int?
    var name: String?
     
    var  fullname: String? {
        return ((name ?? "") + ", Egypt." )
    }

}


