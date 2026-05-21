//
//  BookingRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol BookingRepositoryProtocol {
    func createBooking(clinicId: Int, dto: AppointmentWriteDTO) async throws
    func getUserAppointments() async throws -> [AppointmentReadDTO]
}

final class BookingRepository: BookingRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func createBooking(clinicId: Int, dto: AppointmentWriteDTO) async throws {
        let _: AppointmentReadDTO = try await apiClient.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/appointments/",
            method: "POST",
            body: dto,
            requiresAuth: true
        )
    }

    func getUserAppointments() async throws -> [AppointmentReadDTO] {
        let response: PaginatedResponse<AppointmentReadDTO> = try await apiClient.request(
            endpoint: "\(APIConfig.shared.baseURL)/users/me/appointments/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )

        return response.results
    }
}
