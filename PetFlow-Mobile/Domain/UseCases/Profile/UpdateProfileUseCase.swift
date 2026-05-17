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

    func execute(dto: UserProfileDTO) async throws {
        try await repository.updateProfile(dto: dto)
    }
}
