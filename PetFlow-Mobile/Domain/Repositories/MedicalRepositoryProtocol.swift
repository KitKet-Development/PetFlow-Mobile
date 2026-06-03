//
//  MedicalRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import Foundation

protocol MedicalCardRepositoryProtocol {
    func getMedicalCard(petId: Int) async throws -> MedicalCardDTO
    func updateMedicalCard(petId: Int, dto: MedicalCardUpdateDTO) async throws -> MedicalCardDTO
    func downloadAttachment(petId: Int, visitId: Int) async throws -> Data
}
