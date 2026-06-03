//
//  OwnerAppoinmentUIModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct OwnerAppointmentUIModel: Identifiable {
    let id: Int
    let petName: String
    let ownerName: String
    let date: String
    let time: String
    let status: String
    let statusColor: String
}
