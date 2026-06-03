//
//  AppointmentUserDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

struct AppointmentUserDTO: Codable, Hashable {
    let id: Int
    let full_name: String
    let email: String
    let phone: String?
}
