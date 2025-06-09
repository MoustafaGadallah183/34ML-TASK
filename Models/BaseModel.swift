//
//  BaseModel.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import Foundation

struct HomeResponse: Codable {
    var meta: Meta?
    var data: [ExperienceModel]?
   
}

struct ExperienceDetailsResponse: Codable {
    var meta: Meta?
    var data: ExperienceModel?
   
}


struct Meta: Codable {
    var code: Int?

}


