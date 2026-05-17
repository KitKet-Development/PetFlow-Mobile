//
//  ClinicCatalogViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation
import Combine

@MainActor
final class ClinicCatalogViewModel: ObservableObject {

    @Published var clinics: [ClinicDTO] = []
    @Published var isLoading = false

    private let useCase: GetClinicsUseCase

    init(
        useCase: GetClinicsUseCase = GetClinicsUseCase(
            repository: AppContainer.shared.clinicRepository
        )
    ) {
        self.useCase = useCase
    }

    func loadClinics() async {

        do {
            isLoading = true
            clinics = try await useCase.execute()
            isLoading = false

        } catch {
            isLoading = false
            print(error.localizedDescription)
        }
    }
}
