//
//  ClinicDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct ClinicDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String?
    let rating: Double?
    let description: String?
    let phone: String?
}
