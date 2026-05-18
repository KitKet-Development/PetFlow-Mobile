//
//  ProfilelViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

struct PetMock: Identifiable {
    let id = UUID()
    let name: String
    let breed: String
    let imageName: String
}

struct BookingMock: Identifiable {
    let id = UUID()
    let type: String
    let petName: String
    let date: String
    let time: String
    let status: String
    let icon: String
}

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var userName = ""
    @Published var userEmail = ""

    @Published var id = 0
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var password = ""

    @Published var pets: [PetMock] = []
    @Published var bookings: [BookingMock] = []

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let getPetsUseCase: GetPetsUseCase

    init(
        getProfileUseCase: GetProfileUseCase = DependencyContainer.shared.getProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase = DependencyContainer.shared.updateProfileUseCase,
        getPetsUseCase: GetPetsUseCase = DependencyContainer.shared.getPetsUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.getPetsUseCase = getPetsUseCase
    }

    func loadProfile() async {

        do {

            isLoading = true

            let profile = try await getProfileUseCase.execute()

            id = profile.id
            firstName = profile.first_name
            lastName = profile.last_name
            email = profile.email

            userName = "\(profile.first_name) \(profile.last_name)"
            userEmail = profile.email

            isLoading = false

        } catch {

            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func saveChanges() async {

        do {

            isLoading = true

            let dto = UpdateUserDTO(
                first_name: firstName,
                last_name: lastName,
                email: email
            )

            try await updateProfileUseCase.execute(dto: dto)

            userName = "\(firstName) \(lastName)"
            userEmail = email

            isLoading = false

        } catch {

            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func deleteAccount() {

        TokenStorage.shared.clear()

        AppSession.shared.logout()
    }
}
