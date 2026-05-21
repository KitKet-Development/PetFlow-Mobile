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
    @Published var errorMessage: String?

    // Текущие активные фильтры
    @Published var selectedFilter = "Все"
    @Published var searchText = "" {
        didSet {
            // При изменении поиска перезагружаем с задержкой
            searchDebounceTask?.cancel()
            searchDebounceTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 сек
                await fetchClinics()
            }
        }
    }

    private var searchDebounceTask: Task<Void, Never>?

    private let getClinicsUseCase: GetClinicsUseCase

    let filters: [(title: String, params: ClinicFilterParams)] = [
        ("Все",          ClinicFilterParams()),
        ("Рейтинг 4+",   ClinicFilterParams(minRating: 4.0)),
        ("Рейтинг 5",    ClinicFilterParams(minRating: 5.0)),
        ("Собаки",       ClinicFilterParams(species: 1)),
        ("Кошки",        ClinicFilterParams(species: 2)),
    ]

    var filterTitles: [String] {
        filters.map { $0.title }
    }

    init(getClinicsUseCase: GetClinicsUseCase? = nil) {
        self.getClinicsUseCase = getClinicsUseCase
            ?? DependencyContainer.shared.getClinicsUseCase
    }

    func fetchClinics() async {
        do {
            isLoading = true
            errorMessage = nil

            // Берём параметры выбранного фильтра
            var params = filters.first(where: {
                $0.title == selectedFilter
            })?.params ?? ClinicFilterParams()

            // Добавляем поисковый запрос
            if !searchText.isEmpty {
                params.search = searchText
            }

            clinics = try await getClinicsUseCase.execute(filters: params)

            isLoading = false

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }

    func selectFilter(_ title: String) {
        selectedFilter = title
        Task {
            await fetchClinics()
        }
    }
}
