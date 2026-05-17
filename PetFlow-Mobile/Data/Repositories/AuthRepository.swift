//
//  AuthRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let apiClient: APIClientProtocol
    private let tokenStorage: TokenStorageProtocol

    init(
        apiClient: APIClientProtocol,
        tokenStorage: TokenStorageProtocol
    ) {
        self.apiClient = apiClient
        self.tokenStorage = tokenStorage
    }

    func register(dto: RegisterRequestDTO) async throws {
        let _: RegisterRequestDTO = try await apiClient.request(
            endpoint: APIConfig.Path.signup,
            method: .POST,
            body: dto,
            requiresAuth: false
        )
    }

    func login(dto: LoginRequestDTO) async throws -> TokenResponseDTO {

        let response: TokenResponseDTO = try await apiClient.request(
            endpoint: APIConfig.Path.login,
            method: .POST,
            body: dto,
            requiresAuth: false
        )

        tokenStorage.saveAccessToken(response.access)

        return response
    }
}
