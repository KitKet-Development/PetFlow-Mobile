//
//  GetProfileUseCase.swift
//  PetFlow-Mobile
//
//  Created by [Your Name] on [Date].
//

import Foundation

final class GetProfileUseCase {

    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserDTO {
        try await repository.getProfile()
    }
}
