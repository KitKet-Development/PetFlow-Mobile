//
//  PetWriteResponseDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

struct PetWriteResponseDTO: Decodable {
    let id: Int
    let owner: Int
    let name: String
    let species: SpeciesDTO
    let breed: BreedDTO?
    let birth_date: String?
    let weight: String?
    let avatar: String?
}
