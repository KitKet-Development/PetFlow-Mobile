//
//  AppContainer.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class AppContainer {

    static let shared = AppContainer()

    private init() {}

    lazy var tokenStorage: TokenStorageProtocol = TokenStorage()

    lazy var apiClient: APIClientProtocol = APIClient(
        tokenStorage: tokenStorage
    )

    lazy var authRepository: AuthRepositoryProtocol = AuthRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage
    )

    lazy var clinicRepository: ClinicRepositoryProtocol = ClinicRepository(
        apiClient: apiClient
    )

    lazy var petRepository: PetRepositoryProtocol = PetRepository(
        apiClient: apiClient
    )

    lazy var bookingRepository: BookingRepositoryProtocol = BookingRepository(
        apiClient: apiClient
    )

    lazy var profileRepository: ProfileRepositoryProtocol = ProfileRepository(
        apiClient: apiClient
    )
}
