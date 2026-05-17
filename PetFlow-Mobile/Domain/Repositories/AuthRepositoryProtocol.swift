//
//  AuthRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func register(dto: RegisterRequestDTO) async throws
    func login(dto: LoginRequestDTO) async throws -> TokenResponseDTO
}
