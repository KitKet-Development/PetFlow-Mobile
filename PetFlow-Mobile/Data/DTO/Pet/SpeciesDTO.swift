//
//  HealthRecordDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct SpeciesDTO: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
}
