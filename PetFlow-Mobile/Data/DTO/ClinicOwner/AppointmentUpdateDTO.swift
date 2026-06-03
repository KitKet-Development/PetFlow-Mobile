//
//  AppointmentUpdateDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import Foundation

struct AppointmentUpdateDTO: Encodable {
    let pet: Int?
    let date: String?
    let slot: Int?
    let comment: String?
    let status: String?
}

struct PetUpdateDTO: Encodable {

    let name: String
    let species: Int
    let breed: Int?
    let birth_date: String?
    let weight: String?
    let gender: String?
    let color: String?
    let microchip: String?
    let allergies: String?
}
