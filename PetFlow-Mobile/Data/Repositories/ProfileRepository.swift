//
//  ProfileRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getProfile() async throws -> UserDTO {
        try await apiClient.request(
            endpoint: APIConfig.shared.meURL,
            method: "GET",
            body: nil,
            requiresAuth: true
        )
    }
    
    func updateProfile(dto: UpdateUserDTO) async throws {
        var fields: [String: String] = [
            "first_name": dto.first_name,
            "last_name": dto.last_name,
            "email": dto.email
        ]
        
        if let phone = dto.phone, !phone.isEmpty {
            fields["phone"] = phone
        }
        
        let _: UserDTO = try await apiClient.uploadMultipart(
            endpoint: APIConfig.shared.meURL,
            method: "PATCH",
            fields: fields,
            imageData: dto.avatar,
            imageFieldName: "avatar",
            requiresAuth: true
        )
    }
}
