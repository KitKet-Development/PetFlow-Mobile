//
//  VetDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct VetProfileReadDTO: Codable, Identifiable {
    let id: Int
    let full_name: String
    let specialization: String?
    let phone: String?
    let email: String?
    let bio: String?
    let avatar: String?
}
