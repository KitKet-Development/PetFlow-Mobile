//
//  ClinicRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class ClinicRepository: ClinicRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getClinics() async throws -> [ClinicDTO] {
        try await apiClient.request(
            endpoint: APIConfig.Path.clinics,
            method: .GET,
            body: nil,
            requiresAuth: true
        )
    }
}
