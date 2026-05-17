//
//  Clinic.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct Clinic: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let distance: String
    let rating: String
    let price: String
    let category: String
    let description: String
    let phone: String
    let workingHours: String
    let imageName: String
}
