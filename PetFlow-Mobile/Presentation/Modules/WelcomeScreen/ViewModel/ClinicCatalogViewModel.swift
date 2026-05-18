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

    private let repository = DependencyContainer.shared.clinicRepository

    func fetchClinics() {

        Task {
            await loadClinics()
        }
    }

    private func loadClinics() async {

        do {

            isLoading = true

            clinics = try await repository.getClinics()

        } catch {
            print(error.localizedDescription)
        }

        isLoading = false
    }
}
