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
        let response: SignUpResponseDTO = try await client.request(
            endpoint: endpoint,
            method: "POST",
            body: request
        )
        
        let loginRequest = LoginRequestDTO(email: request.email, password: request.password)
        try await login(request: loginRequest)
    }
 
    func signupOwner(request: SignUpOwnerClinicRequestDTO) async throws {
        let endpoint = "\(APIConfig.shared.authBaseURL)/signup_owner_clinic/"
        let _: SignUpOwnerClinicResponseDTO = try await client.request(
            endpoint: endpoint,
            method: "POST",
            body: request
        )
        let loginRequest = LoginRequestDTO(email: request.email, password: request.password)
        try await login(request: loginRequest)
    }
 
    func login(request: LoginRequestDTO) async throws {
        let endpoint = "\(APIConfig.shared.authBaseURL)/login/"
        let response: TokenResponseDTO = try await client.request(
            endpoint: endpoint,
            method: "POST",
            body: request
        )
 
        TokenStorage.shared.clear()
 
        TokenStorage.shared.accessToken = response.access
        TokenStorage.shared.refreshToken = response.refresh
 
        if let userID = JWTDecoder.decodeUserID(from: response.access) {
            UserDefaults.standard.set(userID, forKey: "current_user_id")
        }
 
        await MainActor.run {
            AppSession.shared.login(role: response.role)
        }
    }
}
