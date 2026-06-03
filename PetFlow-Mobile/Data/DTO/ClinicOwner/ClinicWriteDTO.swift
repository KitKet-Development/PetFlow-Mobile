//
//  ClinicWriteDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct ClinicWriteDTO: Encodable {
    let name: String
    let address: Int
    let phone: String?
    let email: String
    let description: String?
    let species: [Int]
}
