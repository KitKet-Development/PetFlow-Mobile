//
//  BookingViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

@MainActor
final class BookingViewModel: ObservableObject {

    @Published var selectedDate = "12"
    @Published var selectedTime = "10:30"
    @Published var selectedPetId: UUID?
    @Published var comment = ""

    @Published var pets: [PetMock] = []

    @Published var isLoading = false
    @Published var errorMessage: String?

    var days: [(String, String)] {

        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")

        return (0..<5).compactMap { index in

            guard let date = calendar.date(byAdding: .day, value: index, to: Date()) else {
                return nil
            }

            formatter.dateFormat = "EE"
            let day = formatter.string(from: date).uppercased()

            formatter.dateFormat = "dd"
            let number = formatter.string(from: date)

            return (day, number)
        }
    }

    let timeSlots = [
        "09:00",
        "10:30",
        "11:00",
        "13:30",
        "15:00",
        "16:30"
    ]

    private let bookingUseCase: CreateBookingUseCase
    private let getPetsUseCase: GetPetsUseCase

    init(
        bookingUseCase: CreateBookingUseCase = CreateBookingUseCase(
            repository: DependencyContainer.shared.bookingRepository
        ),
        getPetsUseCase: GetPetsUseCase = GetPetsUseCase(
            repository: DependencyContainer.shared.petRepository
        )
    ) {
        self.bookingUseCase = bookingUseCase
        self.getPetsUseCase = getPetsUseCase
    }

    func loadPets() async {

        do {
            isLoading = true

            let dto = try await getPetsUseCase.execute()

            pets = dto.map {
                PetMock(
                    name: $0.name,
                    breed: "Unknown",
                    imageName: "dog_thumb"
                )
            }

            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func confirmBooking(
        clinicId: Int,
        petId: Int
    ) async {

        do {
            isLoading = true

            let dto = BookingDTO(
                id: nil,
                pet: petId,
                clinic: clinicId,
                comment: comment,
                booking_date: selectedDate,
                booking_time: selectedTime
            )

            //try await bookingUseCase.execute(dto: dto)

            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
