//
//  OwnerDashboardUIModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct OwnerDashboardUIModel {
    let clinicName: String
    let clinicAddress: String
    let todayAppointments: Int
    let totalRevenue: String
    let occupancy: Double
    let reviewsCount: Int
    let rating: Double
    let recentAppointments: [OwnerAppointmentUIModel]
}
