//
//  LoginUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class LoginUseCase {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        email: String,
        password: String
    ) async throws {

        let dto = LoginRequestDTO(
            email: email,
            password: password
        )

        _ = try await repository.login(dto: dto)
    }
}
