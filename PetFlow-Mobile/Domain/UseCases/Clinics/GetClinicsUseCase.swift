//
//  GetClinicsUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class GetClinicsUseCase {

    private let repository: ClinicRepositoryProtocol

    init(repository: ClinicRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [ClinicDTO] {
        try await repository.getClinics()
    }
}
