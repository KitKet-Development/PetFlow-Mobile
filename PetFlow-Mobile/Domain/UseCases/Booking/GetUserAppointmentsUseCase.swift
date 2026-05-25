//
//  GetUserAppointmentsUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

import Foundation

final class GetUserAppointmentsUseCase {
    
    private let repository: BookingRepositoryProtocol
    
    init(repository: BookingRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [AppointmentReadDTO] {
        try await repository.getUserAppointments()
    }
}
