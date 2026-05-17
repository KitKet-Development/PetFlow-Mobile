//
//  APIConfig.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct APIConfig {
    static let baseURL = "https://your-api-domain.com"

    struct Path {
        static let login = "/api/v1/auth/login/"
        static let signup = "/api/v1/auth/signup/"

        static let clinics = "/api/v1/clinics/"

        static let pets = "/api/v1/pets/"
        static let breeds = "/api/v1/breeds/"

        static let bookings = "/api/v1/bookings/"

        static let profile = "/api/v1/profile/"
    }
}
