//
//  ProfileRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol ProfileRepositoryProtocol {

    func getProfile() async throws -> UserDTO

    func updateProfile(dto: UpdateUserDTO) async throws
}

final class ProfileRepository: ProfileRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getProfile() async throws -> UserDTO {

        try await apiClient.request(
            endpoint: APIConfig.shared.profileURL,
            method: "GET",
            body: nil,
            requiresAuth: true
        )
    }

    func updateProfile(dto: UpdateUserDTO) async throws {

        let _: UserDTO = try await apiClient.request(
            endpoint: APIConfig.shared.profileURL,
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )
    }
}
