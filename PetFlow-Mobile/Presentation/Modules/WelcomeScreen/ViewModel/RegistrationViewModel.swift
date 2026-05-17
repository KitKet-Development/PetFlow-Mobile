//
//  RegistrationViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 09.05.2026.
//

import Foundation
import Combine

import Foundation

@MainActor
final class RegistrationViewModel: ObservableObject {

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""

    @Published var showValidationError = false
    @Published var errorMessage: String?

    private let session = AppSession.shared

    var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func finishRegistration() {
        guard isFormValid else {
            showValidationError = true
            return
        }

        let userData = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]

        print("Отправка данных на BackEnd: \(userData)")
    }
}
