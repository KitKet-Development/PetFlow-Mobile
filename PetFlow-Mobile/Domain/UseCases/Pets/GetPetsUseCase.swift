//
//  GetPetsUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class GetPetsUseCase {
    
    private let repository: PetRepositoryProtocol
    
    init(repository: PetRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [PetDTO] {
        try await repository.getPets()
    }
}
