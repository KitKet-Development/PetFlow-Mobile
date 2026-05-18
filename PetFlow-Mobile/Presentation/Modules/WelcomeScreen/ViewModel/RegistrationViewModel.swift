//
//  RegistrationViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 09.05.2026.
//

import Foundation
import Combine

@MainActor
final class RegistrationViewModel: ObservableObject {

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var registrationSuccess = false

    private let signUpUseCase = DependencyContainer.shared.signUpUseCase

    func finishRegistration() {

        Task {
            await register()
        }
    }

    private func register() async {

        do {

            isLoading = true

            try await signUpUseCase.execute(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )

            registrationSuccess = true

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
