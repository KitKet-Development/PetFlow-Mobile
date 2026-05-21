//
//  Get.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

final class GetBreedsUseCase {

    private let repository: PetMetaRepositoryProtocol

    init(repository: PetMetaRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [BreedDTO] {
        try await repository.getBreeds()
    }
}
