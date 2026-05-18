//
//  CreateBookingUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class CreateBookingUseCase {

    private let repository: BookingRepositoryProtocol

    init(repository: BookingRepositoryProtocol) {
        self.repository = repository
    }

//    func execute(dto: BookingDTO) async throws {
//        try await repository.createBooking(dto: dto)
//    }
}
