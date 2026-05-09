//
//  RegistrationViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 09.05.2026.
//

import Foundation
import Combine

class RegistrationViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    
    func finishRegistration() {
        let userData = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]
        print("Отправка данных на BackEnd: \(userData)")
    }
}
