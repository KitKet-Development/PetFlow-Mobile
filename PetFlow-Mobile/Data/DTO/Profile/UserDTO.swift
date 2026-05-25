//
//  UserProfileDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct UserDTO: Codable, Identifiable {
    
    let id: Int?
    
    let email: String?
    let phone: String?
    
    let first_name: String?
    let last_name: String?
    
    let avatar: String?
    let bio: String?
    
    let pets: [ProfilePetDTO]?
}
