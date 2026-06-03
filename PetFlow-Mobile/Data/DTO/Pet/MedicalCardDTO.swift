//
//  MedicalCardDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import Foundation

struct ChronicConditionDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let status: String?
}

struct VaccinationDTO: Codable, Identifiable {
    let id: Int
    let visit: Int?
    let name: String
    let vaccinated_at: String
    let expires_at: String?
    let notes: String?
}

struct PetShortDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let species: Int?
}

struct ClinicShortDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let address: Int?
    let phone: String?
}

struct VisitReadDTO: Codable, Identifiable {
    let id: Int
    let pet: PetShortDTO
    let clinic: ClinicShortDTO
    let visit_date: String
    let title: String
    let complaint: String?
    let diagnosis: String?
    let recommendation: String?
    let attachments: String?
}

struct MedicalCardDTO: Codable {
    let id: Int
    let notes: String?
    let allergies: String?
    let conditions: [ChronicConditionDTO]
    let vaccinations: [VaccinationDTO]
    let visits: [VisitReadDTO]
}
