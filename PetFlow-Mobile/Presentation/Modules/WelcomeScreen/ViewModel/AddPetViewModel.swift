//
//  AddPetViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 10.05.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AddPetViewModel: ObservableObject {

    @Published var petName = ""
    @Published var petType = ""
    @Published var selectedSpeciesId: Int?

    @Published var isLoading = false
    @Published var success = false
    @Published var errorMessage: String?

    @Published var species: [SpeciesDTO] = []
    var petTypes: [String] {
        species.map { $0.name }
    }

    private let createPetUseCase = CreatePetUseCase(
        repository: DependencyContainer.shared.petRepository
    )
    private let getSpeciesUseCase = DependencyContainer.shared.getSpeciesUseCase

    func loadMeta() async {
        do {
            species = try await getSpeciesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }

    func onSpeciesSelected(_ name: String) {
        petType = name
        selectedSpeciesId = species.first(where: { $0.name == name })?.id
    }

    func onContinueTap(image: UIImage?) {
        Task {
            await createPet(image: image)
        }
    }

    private func createPet(image: UIImage?) async {

        guard !petName.isEmpty else {
            errorMessage = "Введите кличку питомца"
            return
        }

        guard let speciesId = selectedSpeciesId else {
            errorMessage = "Выберите вид питомца"
            return
        }

        do {
            isLoading = true

            try await createPetUseCase.execute(
                name: petName,
                speciesId: speciesId,
                image: image
            )

            let localPet = LocalPet(
                name: petName,
                type: petType,
                image: image
            )
            LocalStorageService.shared.pets.append(localPet)

            success = true

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func onAddLaterTap() {
        success = true
    }
}
