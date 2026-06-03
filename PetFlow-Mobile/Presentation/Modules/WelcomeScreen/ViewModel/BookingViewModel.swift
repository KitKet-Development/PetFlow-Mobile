//
//  BookingViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

struct BookingPetUIModel: Identifiable {
    let id: Int
    let name: String
    let species: String
    let breed: String
    let imageURL: String?
}

struct AppointmentCardUIModel: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let status: String
}

@MainActor
final class BookingViewModel: ObservableObject {
    
    @Published var selectedDate = ""
    @Published var selectedTime = ""
    @Published var selectedPetId: Int?
    @Published var selectedSlotId: Int?
    @Published var comment = ""
    
    @Published var pets: [BookingPetUIModel] = []
    @Published var slots: [SlotDTO] = []
    @Published var appointments: [AppointmentCardUIModel] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    var days: [(String, String)] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        return (0..<5).compactMap { index in
            guard let date = calendar.date(
                byAdding: .day, value: index, to: Date()
            ) else { return nil }
            
            formatter.dateFormat = "EE"
            let day = formatter.string(from: date).uppercased()
            
            formatter.dateFormat = "yyyy-MM-dd"
            let apiDate = formatter.string(from: date)
            
            return (day, apiDate)
        }
    }
    
    private let bookingUseCase: CreateBookingUseCase
    private let getPetsUseCase: GetPetsUseCase
    private let getSlotsUseCase: GetSlotsUseCase
    private let getUserAppointmentsUseCase: GetUserAppointmentsUseCase
    
    init(
        bookingUseCase: CreateBookingUseCase? = nil,
        getPetsUseCase: GetPetsUseCase? = nil,
        getSlotsUseCase: GetSlotsUseCase? = nil,
        getUserAppointmentsUseCase: GetUserAppointmentsUseCase? = nil
    ) {
        self.bookingUseCase = bookingUseCase
        ?? DependencyContainer.shared.createBookingUseCase
        self.getPetsUseCase = getPetsUseCase
        ?? DependencyContainer.shared.getPetsUseCase
        self.getSlotsUseCase = getSlotsUseCase
        ?? DependencyContainer.shared.getSlotsUseCase
        self.getUserAppointmentsUseCase = getUserAppointmentsUseCase
        ?? DependencyContainer.shared.getUserAppointmentsUseCase
    }
    
    func loadData(clinicId: Int) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadPets() }
            group.addTask { await self.loadSlots(clinicId: clinicId) }
            group.addTask { await self.loadAppointments() }
        }
    }
    
    func loadPets() async {
        do {
            let dto = try await getPetsUseCase.execute()
            
            pets = dto.map {
                BookingPetUIModel(
                    id: $0.id,
                    name: $0.name,
                    species: $0.species.name,
                    breed: $0.breed?.name ?? "",
                    imageURL: $0.avatar
                )
            }
            
            if selectedPetId == nil {
                selectedPetId = pets.first?.id
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadSlots(clinicId: Int) async {
        do {
            slots = try await getSlotsUseCase.execute(clinicId: clinicId)
            
            if selectedSlotId == nil {
                selectedSlotId = slots.first?.id
                selectedTime = slots.first?.start_time ?? ""
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadAppointments() async {
        do {
            let items = try await getUserAppointmentsUseCase.execute()
            
            appointments = items.map {
                AppointmentCardUIModel(
                    id: $0.id,
                    title: "\($0.clinic.name) • \($0.pet.name)",
                    subtitle: "\($0.date) • \($0.slot.start_time)-\($0.slot.end_time)",
                    status: mapStatus($0.status)
                )
            }
            
        } catch {
        }
    }
    
    private func mapStatus(_ status: String?) -> String {
        switch status {
        case "pending":   return "Ожидает подтверждения"
        case "confirmed": return "Подтверждено"
        case "canceled":  return "Отменено"
        case "completed": return "Завершено"
        default:          return "Неизвестно"
        }
    }
    
    func confirmBooking(clinicId: Int) async {
        
        guard let selectedPetId else {
            errorMessage = "Выберите питомца"
            return
        }
        
        guard let selectedSlotId else {
            errorMessage = "Выберите временной слот"
            return
        }
        
        guard !selectedDate.isEmpty else {
            errorMessage = "Выберите дату"
            return
        }
        
        do {
            isLoading = true
            errorMessage = nil
            successMessage = nil
            
            let dto = AppointmentWriteDTO(
                pet: selectedPetId,
                date: selectedDate,
                slot: selectedSlotId,
                comment: comment.isEmpty ? nil : comment
            )
            
            try await bookingUseCase.execute(clinicId: clinicId, dto: dto)
            successMessage = "Запись успешно создана"
            await loadAppointments()
            isLoading = false
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
