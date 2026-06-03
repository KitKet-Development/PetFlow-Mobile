//
//  ProfilePetDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//

struct ProfilePetDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let species: Int?
    let breed: BreedReadSimpleDTO?
    let avatar: String?
}
