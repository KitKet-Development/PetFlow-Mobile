//
//  AddPetViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 10.05.2026.
//

import Foundation
import Combine

class AddPetViewModel: ObservableObject {
    @Published var petName = ""
    @Published var petType = ""
    let petTypes = ["Собака", "Кот", "Попугай", "Грызун", "Другое"]
    
    func onContinueTap() {
        print("Сохранение питомца: \(petName), вид: \(petType)")
    }
    
    func onAddLaterTap() {
        print("Пропуск шага")
    }
}
