//
//  ProfileRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> UserProfileDTO
    func updateProfile(dto: UserProfileDTO) async throws
}

final class ProfileRepository: ProfileRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getProfile() async throws -> UserProfileDTO {
        try await apiClient.request(
            endpoint: APIConfig.Path.profile,
            method: .GET,
            body: nil,
            requiresAuth: true
        )
    }

    func updateProfile(dto: UserProfileDTO) async throws {
        let _: UserProfileDTO = try await apiClient.request(
            endpoint: APIConfig.Path.profile,
            method: .PATCH,
            body: dto,
            requiresAuth: true
        )
    }
}
