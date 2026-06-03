//
//  GetVetUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation
 
final class GetVetsUseCase {
 
    private let repository: ClinicRepositoryProtocol
 
    init(repository: ClinicRepositoryProtocol) {
        self.repository = repository
    }
 
    func execute(clinicId: Int) async throws -> [VetProfileReadDTO] {
        try await repository.getVets(clinicId: clinicId)
    }
}
