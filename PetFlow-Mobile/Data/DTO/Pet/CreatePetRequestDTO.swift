//
//  CreatePetRequestDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

struct CreatePetRequestDTO: Encodable {
    
    let name: String
    let species: Int
    let breed: Int?
}
