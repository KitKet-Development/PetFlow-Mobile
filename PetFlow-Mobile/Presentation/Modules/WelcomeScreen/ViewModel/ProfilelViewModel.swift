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

class ProfileViewModel: ObservableObject {
    @Published var userName = "Иван Иванов"
    @Published var userEmail = "ivanov.petcare@example.com"
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var pets = [
        PetMock(name: "Барни", breed: "Золотистый ретривер", imageName: "dog_thumb"),
        PetMock(name: "Луна", breed: "Шотландская", imageName: "cat_thumb")
    ]
    
    @Published var bookings = [
        BookingMock(type: "Вакцинация", petName: "Барни", date: "15 Октября", time: "10:30", status: "Скоро", icon: ProfileViewImages.vaccinationIcon),
        BookingMock(type: "Груминг", petName: "Луна", date: "28 Сентября", time: "14:00", status: "Завершено", icon: ProfileViewImages.groomingIcon)
    ]

    func saveChanges() {
        print("Saving changes:", firstName, lastName, phone, email, password)
    }

    func deleteAccount() {
        print("Account deletion initiated")
    }
}
