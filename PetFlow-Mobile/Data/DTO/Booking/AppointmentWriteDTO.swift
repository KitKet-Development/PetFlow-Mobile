//
//  AppointmentWriteDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

import Foundation

struct AppointmentWriteDTO: Codable {
    let pet: Int
    let date: String
    let slot: Int
    let comment: String?
}
