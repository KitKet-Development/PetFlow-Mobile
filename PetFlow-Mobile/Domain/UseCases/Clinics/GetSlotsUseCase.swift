//
//  GetSlotsUseCase.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

final class GetSlotsUseCase {
    
    private let repository: ClinicRepositoryProtocol
    
    init(repository: ClinicRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(clinicId: Int) async throws -> [SlotDTO] {
        try await repository.getSlots(clinicId: clinicId)
    }
}
