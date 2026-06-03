//
//  SignUpOwnerClinicResponseDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct SignUpOwnerClinicResponseDTO: Decodable {
    let email: String
    let first_name: String
    let last_name: String
}
