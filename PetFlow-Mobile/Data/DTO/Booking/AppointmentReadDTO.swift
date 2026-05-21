//
//  AppointmentReadDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

import Foundation

struct AppointmentReadDTO: Codable, Identifiable {
    let id: Int
    let pet: AppointmentPetDTO
    let date: String
    let clinic: AppointmentClinicDTO
    let slot: AppointmentSlotDTO
    let comment: String?
    let user: AppointmentUserDTO
    let status: String?
}

struct AppointmentPetDTO: Codable {
    let id: Int
    let name: String
    let species: Int
}

struct AppointmentClinicDTO: Codable {
    let id: Int
    let name: String
    let address: Int
    let phone: String?
    let email: String
}

struct AppointmentSlotDTO: Codable {
    let start_time: String
    let end_time: String
}

struct AppointmentUserDTO: Codable {
    let id: Int
    let full_name: String
    let email: String
    let phone: String?
}
