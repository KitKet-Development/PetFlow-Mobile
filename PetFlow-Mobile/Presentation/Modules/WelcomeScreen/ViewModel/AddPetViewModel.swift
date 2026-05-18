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

    @Published var isLoading = false
    @Published var success = false
    @Published var errorMessage: String?

    let petTypes = ["Собака", "Кот"]

    private let createPetUseCase = CreatePetUseCase(
        repository: DependencyContainer.shared.petRepository
    )

    func onContinueTap(
        image: UIImage?
    ) {

        Task {
            await createPet(image: image)
        }
    }

    private func createPet(
        image: UIImage?
    ) async {

        do {

            isLoading = true

            try await createPetUseCase.execute(
                name: petName,
                type: petType
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
