//
//  GetMedicalCardUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import Foundation

final class GetMedicalCardUseCase {

    private let repository: MedicalCardRepositoryProtocol

    init(repository: MedicalCardRepositoryProtocol) {
        self.repository = repository
    }

    func execute(petId: Int) async throws -> MedicalCardDTO {
        try await repository.getMedicalCard(petId: petId)
    }
}

final class DownloadVisitAttachmentUseCase {

    private let repository: MedicalCardRepositoryProtocol

    init(repository: MedicalCardRepositoryProtocol) {
        self.repository = repository
    }

    func execute(petId: Int, visitId: Int) async throws -> Data {
        try await repository.downloadAttachment(petId: petId, visitId: visitId)
    }
}
