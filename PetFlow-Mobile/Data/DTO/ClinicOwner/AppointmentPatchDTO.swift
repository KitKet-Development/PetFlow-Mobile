//
//  AppointmentPatchDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import Foundation

struct AppointmentPatchDTO: Encodable {
    let date: String?
    let slot: Int?
    let comment: String?
    let status: String?
}
