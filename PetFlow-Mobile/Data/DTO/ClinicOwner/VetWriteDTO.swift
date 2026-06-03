//
//  VetWriteDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct VetWriteDTO: Encodable {
    let first_name: String
    let last_name: String
    let specialization: String?
    let phone: String?
    let email: String?
    let bio: String?
}
