//
//  ProfileRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol ProfileRepositoryProtocol {

    func getProfile(userID: Int) async throws -> UserDTO

    func updateProfile(
        userID: Int,
        dto: UpdateUserDTO
    ) async throws
}

final class ProfileRepository: ProfileRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getProfile(userID: Int) async throws -> UserDTO {

        try await apiClient.request(
            endpoint: APIConfig.shared.profileURL(
                userID: userID
            ),
            method: "GET",
            body: nil,
            requiresAuth: true
        )
    }

    func updateProfile(
        userID: Int,
        dto: UpdateUserDTO
    ) async throws {

        let fields = [
            "first_name": dto.first_name,
            "last_name": dto.last_name,
            "email": dto.email,
            "phone": dto.phone ?? ""
        ]

        let _: UserDTO = try await apiClient.uploadMultipart(
            endpoint: APIConfig.shared.profileURL(userID: userID),
            method: "PATCH",
            fields: fields,
            imageData: dto.avatar,
            imageFieldName: "avatar",
            requiresAuth: true
        )
    }
}
