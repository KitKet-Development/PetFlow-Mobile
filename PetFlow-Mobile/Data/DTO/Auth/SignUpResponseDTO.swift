//
//  SignUpResponseDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

struct SignUpResponseDTO: Decodable {
    let email: String
    let first_name: String
    let last_name: String
}
