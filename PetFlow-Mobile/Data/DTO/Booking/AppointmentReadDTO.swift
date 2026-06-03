//
//  AppointmentReadDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

import Foundation

struct AppointmentReadDTO: Codable, Identifiable, Hashable {

    let id: Int
    let pet: AppointmentPetDTO
    let date: String
    let clinic: AppointmentClinicDTO
    let slot: AppointmentSlotDTO
    let comment: String?
    let user: AppointmentUserDTO
    let status: String?
}
