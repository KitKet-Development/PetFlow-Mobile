//
//  ProfileRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//


protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> UserDTO
    func updateProfile(dto: UpdateUserDTO) async throws
}
