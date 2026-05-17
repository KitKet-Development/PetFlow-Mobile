//
//  RegisterRequstDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct RegisterRequestDTO: Codable {
    let first_name: String
    let last_name: String
    let email: String
    let password: String
}
