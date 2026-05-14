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

class PetDetailViewModel: ObservableObject {
    @Published var petName = "Барни"
    @Published var breed = "Золотистый ретривер"
    @Published var age = "3 месяца"
    
    @Published var healthRecords = [
        HealthRecord(date: "14 ЯНВ 2024", title: "Плановый осмотр", description: "Состояние отличное. Рекомендовано увеличение физической нагрузки.", doctor: "Д-р Васильева", fileName: "check-up_jan24.pdf"),
        HealthRecord(date: "20 НОЯ 2023", title: "Чистка зубов", description: "Удален зубной камень, десна в норме.", doctor: nil, fileName: nil)
    ]
}
