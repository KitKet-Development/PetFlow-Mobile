//
//  AuthRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {

    private let client = APIClient.shared

    func signup(request: SignUpRequestDTO) async throws {

        let endpoint = "\(APIConfig.shared.authBaseURL)/signup/"

        let _: UserDTO = try await client.request(
            endpoint: endpoint,
            method: "POST",
            body: request
        )
    }

    func login(request: LoginRequestDTO) async throws {

        let endpoint = "\(APIConfig.shared.authBaseURL)/login/"

        let response: TokenResponseDTO = try await client.request(
            endpoint: endpoint,
            method: "POST",
            body: request
        )

        TokenStorage.shared.accessToken = response.access
        TokenStorage.shared.refreshToken = response.refresh
    }
}
