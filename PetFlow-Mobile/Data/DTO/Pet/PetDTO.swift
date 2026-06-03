//
//  PetDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct PetDTO: Codable, Identifiable, Hashable, Equatable {

    let id: Int
    let owner: Int

    let name: String

    let species: SpeciesDTO
    let breed: BreedReadSimpleDTO?

    let birth_date: String?
    let weight: String?

    let avatar: String?
}
