//
//  ClinicRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol ClinicRepositoryProtocol {

    func getClinics() async throws -> [ClinicDTO]
}
