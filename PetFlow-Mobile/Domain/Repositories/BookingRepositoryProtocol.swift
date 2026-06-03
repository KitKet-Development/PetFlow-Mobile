//
//  BookingRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

protocol BookingRepositoryProtocol {
    func createBooking(clinicId: Int, dto: AppointmentWriteDTO) async throws
    func getUserAppointments() async throws -> [AppointmentReadDTO]
}
