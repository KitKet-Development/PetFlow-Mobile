//
//  ClinicRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class ClinicRepository: ClinicRepositoryProtocol {

    private let client = APIClient.shared

    func getClinics() async throws -> [ClinicDTO] {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/",
            requiresAuth: false
        )
    }
}

