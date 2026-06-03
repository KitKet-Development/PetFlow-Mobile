//
//  AuthRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func signup(request: SignUpRequestDTO) async throws
    func signupOwner(request: SignUpOwnerClinicRequestDTO) async throws
    func login(request: LoginRequestDTO) async throws
}
