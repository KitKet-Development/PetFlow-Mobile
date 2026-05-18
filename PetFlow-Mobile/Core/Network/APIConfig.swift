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

    var profileURL: String {
        "\(baseURL)/profile/"
    }
}
