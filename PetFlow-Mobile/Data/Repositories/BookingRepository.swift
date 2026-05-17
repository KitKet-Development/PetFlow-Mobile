//
//  BookingRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol BookingRepositoryProtocol {
    func createBooking(dto: BookingDTO) async throws
}

final class BookingRepository: BookingRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func createBooking(dto: BookingDTO) async throws {
        let _: BookingDTO = try await apiClient.request(
            endpoint: APIConfig.Path.bookings,
            method: .POST,
            body: dto,
            requiresAuth: true
        )
    }
}
