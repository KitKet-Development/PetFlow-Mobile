//
//  OwnerRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

final class OwnerRepository: OwnerRepositoryProtocol {

    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient.shared) {
        self.client = client
    }

    func getMyClinic() async throws -> ClinicDTO {

        let userId = UserDefaults.standard.integer(forKey: "current_user_id")

        let response: PaginatedResponse<ClinicDTO> = try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/?owner=\(userId)",
            method: "GET",
            body: nil,
            requiresAuth: true
        )

        guard let clinic = response.results.first else {
            throw APIError.serverError("Клиника не найдена")
        }

        return clinic
    }

    func updateClinic(
        clinicId: Int,
        dto: ClinicWriteDTO
    ) async throws -> ClinicDTO {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/",
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )
    }

    func getClinicAppointments(
        clinicId: Int
    ) async throws -> [AppointmentReadDTO] {

        var allAppointments: [AppointmentReadDTO] = []

        var nextURL: String? =
        "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/appointments/"

        while let url = nextURL {

            let response: PaginatedResponse<AppointmentReadDTO> =
            try await client.request(
                endpoint: url,
                method: "GET",
                body: nil,
                requiresAuth: true
            )

            allAppointments.append(contentsOf: response.results)

            nextURL = response.next

            print("📄 Загружено \(response.results.count) записей")
            print("📄 Следующая страница: \(response.next ?? "нет")")
        }

        print("✅ Всего записей: \(allAppointments.count)")

        return allAppointments.sorted {
            "\($0.date) \($0.slot.start_time)"
            <
            "\($1.date) \($1.slot.start_time)"
        }
    }

    func updateAppointmentStatus(
        clinicId: Int,
        appointmentId: Int,
        status: String
    ) async throws {

        let dto = AppointmentStatusDTO(status: status)

        let _: AppointmentReadDTO =
        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/appointments/\(appointmentId)/",
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )
    }

    func updateAppointment(
        clinicId: Int,
        appointmentId: Int,
        dto: AppointmentPatchDTO
    ) async throws -> AppointmentReadDTO {

        print("📤 PATCH appointment \(appointmentId)")
        print("📤 date = \(dto.date ?? "nil")")
        print("📤 slot = \(dto.slot?.description ?? "nil")")
        print("📤 status = \(dto.status ?? "nil")")

        let updated: AppointmentReadDTO = try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/appointments/\(appointmentId)/",
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )

        print("✅ Appointment updated: \(updated.id)")

        return updated
    }

    func deleteAppointment(
        clinicId: Int,
        appointmentId: Int
    ) async throws {

        try await client.requestNoContent(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/appointments/\(appointmentId)/",
            method: "DELETE",
            requiresAuth: true
        )
    }

    // MARK: - Slots

    func getClinicSlots(
        clinicId: Int
    ) async throws -> [SlotDTO] {

        let response: PaginatedResponse<SlotDTO> =
        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/slots/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )

        return response.results
    }

    func createSlot(
        clinicId: Int,
        dto: SlotWriteDTO
    ) async throws -> SlotDTO {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/slots/",
            method: "POST",
            body: dto,
            requiresAuth: true
        )
    }

    func deleteSlot(
        clinicId: Int,
        slotId: Int
    ) async throws {

        try await client.requestNoContent(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/slots/\(slotId)/",
            method: "DELETE",
            requiresAuth: true
        )
    }

    func getClinicVets(
        clinicId: Int
    ) async throws -> [VetProfileReadDTO] {

        let response: PaginatedResponse<VetProfileReadDTO> =
        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/vets/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )

        return response.results
    }

    func createVet(
        clinicId: Int,
        dto: VetWriteDTO
    ) async throws -> VetProfileReadDTO {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/vets/",
            method: "POST",
            body: dto,
            requiresAuth: true
        )
    }

    func deleteVet(
        clinicId: Int,
        vetId: Int
    ) async throws {

        try await client.requestNoContent(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/vets/\(vetId)/",
            method: "DELETE",
            requiresAuth: true
        )
    }

    func getClients() async throws -> [UserShortDTO] {

        let response: PaginatedResponse<UserShortDTO> =
        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/users/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )

        return response.results
    }

    func getPet(
        petId: Int
    ) async throws -> PetDTO {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/pets/\(petId)/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )
    }

    func updatePet(
        petId: Int,
        dto: PetUpdateDTO
    ) async throws -> PetDTO {

        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/pets/\(petId)/",
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )
    }
}
