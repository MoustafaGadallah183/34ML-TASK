//
//  EndPoint.swift
//  34MLTask
//
//  Created by Moustafa Mohamed Gadallah on 11/12/1446 AH.
//

import Foundation

enum APIMethod {
    
    case get
    case post
    case put
    case delete
}

enum APIEncoding {
    
    case url
    case json
    case query
}


struct EndPoint {
    
    // MARK: - Variables
    
    var method: APIMethod
    var parameters: [String : Any]?
    var encoding: APIEncoding?
    var headers: [String : Any]?
    var configurations: APIConfiguration?
    var fullURL: String?
    
    var url: String {
        
        return fullURL ?? "\(environment.baseURL)"
        
    }
    
    // MARK: - Initialization

    init() {
    
        self.method = .post
        self.parameters = nil
        self.encoding = nil
        self.headers = nil
        self.fullURL = nil
    }
    

    init(
        method: APIMethod? = .post,
         parameters: [String : Any]? = nil,
         encoding: APIEncoding? = nil,
         headers: [String : Any]? = nil,
         fullURL: String? = nil) {
        self.method = method ?? .post
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.fullURL = fullURL
    }
}

