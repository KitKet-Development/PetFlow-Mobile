//
//  ClinicDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation
import Combine

struct ClinicDTO: Codable, Identifiable, Hashable {

    let id: Int

    let name: String
    let phone: String?
    let email: String?
    let description: String?

    let logo: String?
    let rating: Double?

    let address: AddressDTO?
}
