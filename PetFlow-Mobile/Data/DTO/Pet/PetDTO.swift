//
//  PetDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct PetDTO: Codable, Identifiable {
    
    let id: Int
    let name: String
    let species: Int
    let breed: Int?
    let photo: String?
}
