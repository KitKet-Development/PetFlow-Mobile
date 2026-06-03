//
//  UserShortDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct UserShortDTO: Codable, Identifiable {
    let id: Int
    let email: String
    let phone: String?
    let first_name: String?
    let last_name: String?
    let avatar: String?
    let pets: [ProfilePetDTO]?
}
