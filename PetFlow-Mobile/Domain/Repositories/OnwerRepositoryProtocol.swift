//
//  OnwerRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation
 
protocol OwnerRepositoryProtocol {
    func getMyClinic() async throws -> ClinicDTO
    func updateClinic(clinicId: Int, dto: ClinicWriteDTO) async throws -> ClinicDTO
    func getClinicAppointments(clinicId: Int) async throws -> [AppointmentReadDTO]
    func updateAppointmentStatus(clinicId: Int, appointmentId: Int, status: String) async throws
    func updateAppointment(clinicId: Int, appointmentId: Int, dto: AppointmentPatchDTO) async throws -> AppointmentReadDTO
    func deleteAppointment(clinicId: Int, appointmentId: Int) async throws
    func getClinicSlots(clinicId: Int) async throws -> [SlotDTO]
    func createSlot(clinicId: Int, dto: SlotWriteDTO) async throws -> SlotDTO
    func deleteSlot(clinicId: Int, slotId: Int) async throws
    func getClinicVets(clinicId: Int) async throws -> [VetProfileReadDTO]
    func createVet(clinicId: Int, dto: VetWriteDTO) async throws -> VetProfileReadDTO
    func deleteVet(clinicId: Int, vetId: Int) async throws
    func getClients() async throws -> [UserShortDTO]
    func updatePet(petId: Int, dto: PetUpdateDTO) async throws -> PetDTO
    func getPet(petId: Int) async throws -> PetDTO
}
