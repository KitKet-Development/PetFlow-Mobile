//
//  MedicalCardUpdateDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

struct MedicalCardUpdateDTO: Encodable {

    let id: Int
    let notes: String?
    let allergies: String?
    let conditions: [ChronicConditionDTO]
    let vaccinations: [VaccinationDTO]
    let visits: String?
}
