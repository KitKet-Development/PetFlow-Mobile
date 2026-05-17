//
//  PetDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct PetDTO: Codable, Identifiable {
    let id: Int?
    let name: String
    let breed: Int?
    let age: Int?
    let type: String?
}
