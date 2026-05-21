//
//  AddressDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//

struct AddressDTO: Codable, Hashable, Equatable {
    let id: Int
    let city: String
    let street: String
    let house: String
    let full_address: String
}
