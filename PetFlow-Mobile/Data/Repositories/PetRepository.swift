//
//  PetRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class PetRepository: PetRepositoryProtocol {

    private let client = APIClient.shared

    func getPets() async throws -> [PetDTO] {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/pets/",
            requiresAuth: true
        )
    }

    func createPet(request: CreatePetRequestDTO) async throws {

        let _: PetDTO = try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/pets/",
            method: "POST",
            body: request,
            requiresAuth: true
        )
    }
}
