//
//  CreatePetUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class CreatePetUseCase {

    private let repository: PetRepositoryProtocol

    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        name: String,
        type: String
    ) async throws {

        let speciesId = type == "Собака" ? 1 : 2

        let request = CreatePetRequestDTO(
            name: name,
            species: speciesId,
            breed: nil
        )

        try await repository.createPet(request: request)
    }
}
