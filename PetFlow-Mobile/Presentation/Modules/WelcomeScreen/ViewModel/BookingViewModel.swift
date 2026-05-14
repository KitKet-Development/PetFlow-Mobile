//
//  BookingViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

class BookingViewModel: ObservableObject {
    @Published var selectedDate = "12"
    @Published var selectedTime = "10:30"
    @Published var selectedPetId: UUID?
    @Published var comment = ""
    
    let days = [
        ("ПН", "11"), ("ВТ", "12"), ("СР", "13"), ("ЧТ", "14"), ("ПТ", "15")
    ]
    
    let timeSlots = ["09:00", "10:30", "11:00", "13:30", "15:00", "16:30"]
    
    @Published var pets = [
        PetMock(name: "Барон", breed: "Золотистый ретривер", imageName: "dog_thumb"),
        PetMock(name: "Луна", breed: "Шотландская вислоухая", imageName: "cat_thumb")
    ]
    
    func confirmBooking() {
        print("Запись подтверждена на \(selectedDate) в \(selectedTime) для питомца с ID \(String(describing: selectedPetId))")
    }
}
