//
//  PetDetailViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

struct HealthRecord: Identifiable {
    let id = UUID()
    let date: String
    let title: String
    let description: String
    let doctor: String?
    let fileName: String?
}

@MainActor
final class PetDetailViewModel: ObservableObject {

    @Published var pet: LocalPet?
    @Published var healthRecords: [HealthRecord] = [
        // Example data to prevent empty view (optional, adjust as needed)
        HealthRecord(date: "01 Янв 2024", title: "Осмотр", description: "Плановый осмотр, все хорошо.", doctor: "Иванова И.А.", fileName: "osmotrovka.pdf"),
        HealthRecord(date: "10 Фев 2024", title: "Вакцинация", description: "Прививка от бешенства.", doctor: nil, fileName: nil)
    ]

    private let session = AppSession.shared

    func loadPet() {
        pet = session.pets.first
    }
}
