//
//  BookingDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct BookingDTO: Codable, Identifiable {
    let id: Int?
    let pet: Int
    let clinic: Int
    let comment: String?
    let booking_date: String
    let booking_time: String
}
