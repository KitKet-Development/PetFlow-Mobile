//
//  APIConfig.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class APIConfig {
    
    static let shared = APIConfig()
    
    private init() {}
    
    let baseURL = "http://192.168.1.58:8000/api/v1"
    
    var authBaseURL: String {
        "\(baseURL)/auth"
    }
    
    func profileURL(userID: Int) -> String {
        "\(baseURL)/users/\(userID)/"
    }
    
    var breedsURL: String {
        "\(baseURL)/breeds/"
    }
    
    var speciesURL: String {
        "\(baseURL)/species/"
    }
    
    var petsURL: String {
        "\(baseURL)/pets/"
    }
    
    var meURL: String {
        "\(baseURL)/users/me/"
    }
    
    func medicalCardURL(petId: Int) -> String {
        "\(baseURL)/pets/\(petId)/medical-card/"
    }
    
    func downloadAttachmentURL(petId: Int, visitId: Int) -> String {
        "\(baseURL)/pets/\(petId)/visits/\(visitId)/download-attachment/"
    }
}
