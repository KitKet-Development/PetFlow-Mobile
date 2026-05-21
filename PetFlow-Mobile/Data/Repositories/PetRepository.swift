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
        let response: PaginatedResponse<PetDTO> = try await client.request(
            endpoint: APIConfig.shared.petsURL,
            method: "GET",
            body: nil,
            requiresAuth: true
        )
        return response.results
    }

    func createPet(request: CreatePetRequestDTO) async throws {
        let _: PetWriteResponseDTO = try await client.request(
            endpoint: APIConfig.shared.petsURL,
            method: "POST",
            body: request,
            requiresAuth: true
        )
    }
}
