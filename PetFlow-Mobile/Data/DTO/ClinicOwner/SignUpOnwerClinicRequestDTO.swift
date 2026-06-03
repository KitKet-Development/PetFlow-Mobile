//
//  SignUpOnwerClinicRequestDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

struct SignUpOwnerClinicRequestDTO: Encodable {
    let first_name: String
    let last_name: String
    let email: String
    let password: String
}
