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
    private let getPetsUseCase: GetPetsUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let getSpeciesUseCase: GetSpeciesUseCase
    
    init(
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        getSpeciesUseCase: GetSpeciesUseCase,
        getPetsUseCase: GetPetsUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.getSpeciesUseCase = getSpeciesUseCase
        self.getPetsUseCase = getPetsUseCase
    }
    
    @MainActor
    static func makeDefault() -> ProfileViewModel {
        let container = DependencyContainer.shared
        return ProfileViewModel(
            getProfileUseCase: container.getProfileUseCase,
            updateProfileUseCase: container.updateProfileUseCase,
            getSpeciesUseCase: container.getSpeciesUseCase,
            getPetsUseCase: container.getPetsUseCase
        )
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    func loadProfile() async {
        do {
            isLoading = true
            errorMessage = nil

            async let profileTask = getProfileUseCase.execute()
            async let petsTask = getPetsUseCase.execute()

            let (profile, fullPets) = try await (profileTask, petsTask)

            id = profile.id ?? 0
            firstName = profile.first_name ?? ""
            lastName = profile.last_name ?? ""
            email = profile.email ?? ""
            phone = profile.phone ?? ""
            avatarURL = profile.avatar

            pets = fullPets.map { pet in
                ProfilePetUIModel(
                    id: pet.id,
                    name: pet.name,
                    species: pet.species.name,
                    breed: pet.breed?.name ?? "",
                    imageURL: pet.avatar
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

            let imageData = avatarImage?.jpegData(compressionQuality: 0.8)
            print("📸 avatarImage: \(avatarImage != nil ? "есть" : "nil")")
            print("📸 jpegData: \(imageData?.count ?? 0) bytes")

            let dto = UpdateUserDTO(
                first_name: firstName,
                last_name: lastName,
                email: email,
                phone: phone.isEmpty ? nil : phone,
                avatar: imageData
            )

            try await updateProfileUseCase.execute(dto: dto)
            
            avatarImage = nil
            
            await loadProfile()
            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("❌ saveChanges error: \(error)")
        }
    }
    
    func deleteAccount() {
        
        TokenStorage.shared.clear()
        
        AppSession.shared.logout()
    }
}
