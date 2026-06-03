//
//  OwnerDashboardViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation
import Combine

@MainActor
final class OwnerDashboardViewModel: ObservableObject {
    
    @Published var clinic: ClinicDTO?
    @Published var appointments: [AppointmentReadDTO] = []
    @Published var slots: [SlotDTO] = []
    @Published var vets: [VetProfileReadDTO] = []
    @Published var currentPet: PetDTO?
    @Published var currentMedicalCard: MedicalCardDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var selectedDate = Date()
    
    private let repository: OwnerRepositoryProtocol
    private let medicalCardRepository: MedicalCardRepositoryProtocol
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init(
        repository: OwnerRepositoryProtocol? = nil,
        medicalCardRepository: MedicalCardRepositoryProtocol? = nil
    ) {
        self.repository =
        repository
        ?? DependencyContainer.shared.ownerRepository
        
        self.medicalCardRepository =
        medicalCardRepository
        ?? DependencyContainer.shared.medicalCardRepository
    }
    
    var todayCount: Int {
        appointments.filter {
            $0.date == formattedDate(Date())
        }.count
    }
    
    var occupancy: Double {
        guard !slots.isEmpty else { return 0 }
        return min(Double(todayCount) / Double(slots.count), 1)
    }
    
    var clients: [UserShortDTO] {
        
        var seenUsers = Set<Int>()
        
        return appointments.compactMap { appointment in
            
            guard !seenUsers.contains(appointment.user.id)
            else { return nil }
            
            seenUsers.insert(appointment.user.id)
            
            return UserShortDTO(
                id: appointment.user.id,
                email: appointment.user.email,
                phone: appointment.user.phone,
                first_name: nil,
                last_name: nil,
                avatar: nil,
                pets: nil
            )
        }
    }
    
    var appointmentsForSelectedDate: [AppointmentReadDTO] {
        appointments.filter {
            $0.date == formattedDate(selectedDate)
        }
    }
    
    var appointmentUIModels: [OwnerAppointmentUIModel] {
        appointments.map(mapAppointment)
    }
    
    var appointmentsForSelectedDateUIModels: [OwnerAppointmentUIModel] {
        appointmentsForSelectedDate.map(mapAppointment)
    }
    
    func loadAll() async {
        
        errorMessage = nil
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            
            let clinic = try await repository.getMyClinic()
            
            self.clinic = clinic
            
            async let appointmentsTask =
            repository.getClinicAppointments(clinicId: clinic.id)
            
            async let slotsTask =
            repository.getClinicSlots(clinicId: clinic.id)
            
            async let vetsTask =
            repository.getClinicVets(clinicId: clinic.id)
            
            let (appointments, slots, vets) =
            try await (
                appointmentsTask,
                slotsTask,
                vetsTask
            )
            
            self.appointments = appointments
            self.slots = slots
            self.vets = vets
            
        } catch {
            
            errorMessage = error.localizedDescription
            print("❌ OwnerDashboard loadAll:", error)
        }
    }
    
    func loadPet(petId: Int) async {
        
        do {
            
            async let petTask =
            repository.getPet(
                petId: petId
            )
            
            async let medicalTask =
            medicalCardRepository.getMedicalCard(
                petId: petId
            )
            
            let (pet, medicalCard) =
            try await (
                petTask,
                medicalTask
            )
            
            currentPet = pet
            currentMedicalCard = medicalCard
            
        } catch {
            
            errorMessage = error.localizedDescription
            
            print("❌ loadPet:", error)
        }
    }
    
    func updateMedicalCard(
        petId: Int,
        dto: MedicalCardUpdateDTO
    ) async {
        
        do {
            
            let updated =
            try await medicalCardRepository.updateMedicalCard(
                petId: petId,
                dto: dto
            )
            
            currentMedicalCard = updated
            
            successMessage =
            "Медицинская карта обновлена"
            
        } catch {
            
            print("❌ updateMedicalCard:", error)
            
            errorMessage = error.localizedDescription
        }
    }
    
    func confirmAppointment(_ id: Int) async {
        await updateAppointmentStatus(
            id,
            status: "confirmed"
        )
    }
    
    func cancelAppointment(_ id: Int) async {
        await updateAppointmentStatus(
            id,
            status: "canceled"
        )
    }
    
    func completeAppointment(_ id: Int) async {
        await updateAppointmentStatus(
            id,
            status: "completed"
        )
    }
    
    private func updateAppointmentStatus(
        _ appointmentId: Int,
        status: String
    ) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            try await repository.updateAppointmentStatus(
                clinicId: clinicId,
                appointmentId: appointmentId,
                status: status
            )
            
            await loadAll()
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func updateAppointment(
        appointmentId: Int,
        dto: AppointmentPatchDTO
    ) async {
        
        guard let clinicId = clinic?.id else { return }
        
        do {
            
            let updated = try await repository.updateAppointment(
                clinicId: clinicId,
                appointmentId: appointmentId,
                dto: dto
            )
            
            if let idx = appointments.firstIndex(where: { $0.id == appointmentId }) {
                appointments[idx] = updated
            }
            
            successMessage = "Запись обновлена"
            
        } catch {
            
            print("❌ updateAppointment:", error)
            
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAppointment(_ appointmentId: Int) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            try await repository.deleteAppointment(
                clinicId: clinicId,
                appointmentId: appointmentId
            )
            
            appointments.removeAll {
                $0.id == appointmentId
            }
            
            successMessage = "Запись удалена"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func updatePet(
        petId: Int,
        dto: PetUpdateDTO
    ) async {
        
        do {
            
            let pet = try await repository.updatePet(
                petId: petId,
                dto: dto
            )
            
            currentPet = pet
            
            successMessage = "Питомец обновлен"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func createSlot(
        startTime: String,
        endTime: String
    ) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            let dto = SlotWriteDTO(
                start_time: startTime,
                end_time: endTime
            )
            
            let slot =
            try await repository.createSlot(
                clinicId: clinicId,
                dto: dto
            )
            
            slots.append(slot)
            
            successMessage = "Слот добавлен"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteSlot(_ slotId: Int) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            try await repository.deleteSlot(
                clinicId: clinicId,
                slotId: slotId
            )
            
            slots.removeAll {
                $0.id == slotId
            }
            
            successMessage = "Слот удалён"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func createVet(
        firstName: String,
        lastName: String,
        specialization: String,
        phone: String?,
        email: String?,
        bio: String?
    ) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            let dto = VetWriteDTO(
                first_name: firstName,
                last_name: lastName,
                specialization: specialization.isEmpty ? nil : specialization,
                phone: phone?.isEmpty == true ? nil : phone,
                email: email?.isEmpty == true ? nil : email,
                bio: bio?.isEmpty == true ? nil : bio
            )
            
            let vet =
            try await repository.createVet(
                clinicId: clinicId,
                dto: dto
            )
            
            vets.append(vet)
            
            successMessage = "Сотрудник добавлен"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteVet(_ vetId: Int) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            try await repository.deleteVet(
                clinicId: clinicId,
                vetId: vetId
            )
            
            vets.removeAll {
                $0.id == vetId
            }
            
            successMessage = "Сотрудник удалён"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func updateClinic(
        name: String,
        phone: String?,
        email: String,
        description: String?,
        addressId: Int,
        species: [Int]
    ) async {
        
        guard let clinicId = clinic?.id else {
            return
        }
        
        do {
            
            let dto = ClinicWriteDTO(
                name: name,
                address: addressId,
                phone: phone?.isEmpty == true ? nil : phone,
                email: email,
                description: description?.isEmpty == true ? nil : description,
                species: species
            )
            
            clinic = try await repository.updateClinic(
                clinicId: clinicId,
                dto: dto
            )
            
            successMessage = "Данные клиники обновлены"
            
        } catch {
            
            errorMessage = error.localizedDescription
        }
    }
    
    func mapAppointment(
        _ dto: AppointmentReadDTO
    ) -> OwnerAppointmentUIModel {
        
        OwnerAppointmentUIModel(
            id: dto.id,
            petName: dto.pet.name,
            ownerName: dto.user.full_name,
            date: dto.date,
            time: dto.slot.start_time,
            status: mapStatus(dto.status),
            statusColor: statusColor(dto.status)
        )
    }
    
    func mapStatus(_ status: String?) -> String {
        
        switch status {
            
        case "pending":
            return "Ожидает"
            
        case "confirmed":
            return "Подтверждено"
            
        case "canceled":
            return "Отменено"
            
        case "completed":
            return "Завершено"
            
        default:
            return "Неизвестно"
        }
    }
    
    func statusColor(_ status: String?) -> String {
        
        switch status {
            
        case "confirmed":
            return "#63B074"
            
        case "canceled":
            return "#C9554D"
            
        case "completed":
            return "#4A37A7"
            
        default:
            return "#F5A623"
        }
    }
    
    var petAllergies: String {
        currentMedicalCard?.allergies ?? "—"
    }
    
    var petNotes: String {
        currentMedicalCard?.notes ?? "—"
    }
    
    var petConditions: String {
        
        guard let conditions =
                currentMedicalCard?.conditions,
              !conditions.isEmpty
        else {
            return "—"
        }
        
        return conditions
            .map(\.name)
            .joined(separator: ", ")
    }
    
    var petVaccinationsCount: Int {
        currentMedicalCard?.vaccinations.count ?? 0
    }
    
    func formattedDate(_ date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }
}
