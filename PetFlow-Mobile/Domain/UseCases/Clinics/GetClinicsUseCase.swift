//
//  GetClinicsUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct ClinicFilterParams {
    var minRating: Double? = nil
    var species: Int? = nil
    var city: String? = nil
    var search: String? = nil
}

final class GetClinicsUseCase {

    private let repository: ClinicRepositoryProtocol

    init(repository: ClinicRepositoryProtocol) {
        self.repository = repository
    }

    func execute(filters: ClinicFilterParams = ClinicFilterParams()) async throws -> [ClinicDTO] {
        try await repository.getClinics(filters: filters)
    }
}
