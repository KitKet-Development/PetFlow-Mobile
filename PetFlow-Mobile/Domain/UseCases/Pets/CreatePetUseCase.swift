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

        let dto = PetDTO(
            id: nil,
            name: name,
            breed: nil,
            age: nil,
            type: type
        )

        try await repository.createPet(dto: dto)
    }
}
