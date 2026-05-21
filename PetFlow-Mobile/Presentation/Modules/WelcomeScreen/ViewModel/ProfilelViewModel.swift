//
//  ProfilelViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI
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

    @Published var id = 0

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var password = ""

    @Published var avatarURL: String?
    @Published var avatarImage: UIImage?

    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var bookings: [BookingMock] = []
    @Published var pets: [ProfilePetUIModel] = []

    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let getSpeciesUseCase: GetSpeciesUseCase

    init(
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        getSpeciesUseCase: GetSpeciesUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.getSpeciesUseCase = getSpeciesUseCase
    }

    @MainActor
    static func makeDefault() -> ProfileViewModel {
        let container = DependencyContainer.shared
        return ProfileViewModel(
            getProfileUseCase: container.getProfileUseCase,
            updateProfileUseCase: container.updateProfileUseCase,
            getSpeciesUseCase: container.getSpeciesUseCase
        )
    }

    var fullName: String {
        "\(firstName) \(lastName)"
    }

    func loadProfile() async {

        do {
            isLoading = true
            errorMessage = nil

            let userID = UserDefaults.standard.integer(
                forKey: "current_user_id"
            )

            async let profileTask = getProfileUseCase.execute(userID: userID)
            async let speciesTask = getSpeciesUseCase.execute()

            let (profile, speciesList) = try await (profileTask, speciesTask)

            let speciesMap = Dictionary(
                uniqueKeysWithValues: speciesList.map { ($0.id, $0.name) }
            )

            id = profile.id ?? 0
            firstName = profile.first_name ?? ""
            lastName = profile.last_name ?? ""
            email = profile.email ?? ""
            phone = profile.phone ?? ""
            avatarURL = profile.avatar

            pets = (profile.pets ?? []).map {
                ProfilePetUIModel(
                    id: $0.id,
                    name: $0.name,
                    species: speciesMap[$0.species ?? 0] ?? "Питомец",
                    breed: $0.breed?.name ?? "",
                    imageURL: $0.photo
                )
            }

            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print(error)
        }
    }

    func saveChanges() async {

        do {
            isLoading = true

            let dto = UpdateUserDTO(
                first_name: firstName,
                last_name: lastName,
                email: email,
                phone: phone,
                avatar: avatarImage?.jpegData(compressionQuality: 0.8)
            )

            try await updateProfileUseCase.execute(
                userID: id,
                dto: dto
            )

            await loadProfile()

            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print(error)
        }
    }

    func deleteAccount() {

        TokenStorage.shared.clear()

        AppSession.shared.logout()
    }
}
