//
//  PetRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class PetRepository: PetRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func createPet(dto: PetDTO) async throws {
        let _: PetDTO = try await apiClient.request(
            endpoint: APIConfig.Path.pets,
            method: .POST,
            body: dto,
            requiresAuth: true
        )
    }

    func getPets() async throws -> [PetDTO] {
        try await apiClient.request(
            endpoint: APIConfig.Path.pets,
            method: .GET,
            body: nil,
            requiresAuth: true
        )
    }
}
