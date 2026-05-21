//
//  UpdateProfileUseCase.swift
//  PetFlow-Mobile
//
//  
//

import Foundation

final class UpdateProfileUseCase {

    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        userID: Int,
        dto: UpdateUserDTO
    ) async throws {

        try await repository.updateProfile(
            userID: userID,
            dto: dto
        )
    }
}
