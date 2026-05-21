//
//  UserAppointmentDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

import Foundation

struct UserAppointmentDTO: Codable, Identifiable {
    let id: Int
    let pet: Int?
    let clinic: Int?
    let comment: String?
    let booking_date: String?
    let booking_time: String?
    let status: String?
}
