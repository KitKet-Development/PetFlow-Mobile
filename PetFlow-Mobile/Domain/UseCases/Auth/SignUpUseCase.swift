//
//  RegisterUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation


final class SignUpUseCase {

    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        firstName: String,
        lastName: String,
        email: String,
        password: String
    ) async throws {

        let request = SignUpRequestDTO(
            first_name: firstName,
            last_name: lastName,
            email: email,
            password: password
        )

        try await repository.signup(request: request)
    }
}
