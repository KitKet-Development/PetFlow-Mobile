//
//  ClinicDetailViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 27.05.2026.
//

import Foundation
import Combine

enum ClinicDetailTab: String, CaseIterable {
    case price       = "Прайс-лист"
    case reviews     = "Отзывы"
    case specialists = "Специалисты"
}

struct PriceItemUIModel: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let price: String
    let iconName: String
}

struct SpecialistUIModel: Identifiable {
    let id: Int
    let name: String
    let specialization: String
    let experience: String
    let imageURL: String?
    let bio: String?
    let phone: String?
    let email: String?
}

@MainActor
final class ClinicDetailViewModel: ObservableObject {

    @Published var selectedTab: ClinicDetailTab = .price

    @Published var reviews: [ReviewUIModel] = []
    @Published var reviewsPage = 1
    @Published var hasMoreReviews = false
    @Published var isLoadingReviews = false

    @Published var specialists: [SpecialistUIModel] = []
    @Published var isLoadingVets = false
    @Published var hasMoreVets = false

    @Published var errorMessage: String?
    @Published var isFavorite = false

    private let clinicRepository: ClinicRepositoryProtocol
    private let getVetsUseCase: GetVetsUseCase
    private let clinic: ClinicDTO

    init(
        clinic: ClinicDTO,
        clinicRepository: ClinicRepositoryProtocol? = nil,
        getVetsUseCase: GetVetsUseCase? = nil
    ) {
        self.clinic = clinic
        self.clinicRepository = clinicRepository
            ?? DependencyContainer.shared.clinicRepository
        self.getVetsUseCase = getVetsUseCase
            ?? DependencyContainer.shared.getVetsUseCase
    }

    var address: String {
        clinic.address?.full_address ?? "Адрес не указан"
    }

    var workingHours: String {
        "Ежедневно: 09:00 — 21:00"
    }

    var priceItems: [PriceItemUIModel] {
        [
            PriceItemUIModel(id: 1, title: "Первичный приём",   subtitle: "Консультация и осмотр",  price: "1 500 ₽", iconName: "cross.case"),
            PriceItemUIModel(id: 2, title: "Вакцинация",        subtitle: "Комплексная вакцина",     price: "2 200 ₽", iconName: "syringe"),
            PriceItemUIModel(id: 3, title: "Анализ крови",      subtitle: "Общий клинический",       price: "900 ₽",   iconName: "drop.fill"),
            PriceItemUIModel(id: 4, title: "Стерилизация",      subtitle: "Кошки и малые собаки",    price: "4 500 ₽", iconName: "staroflife"),
        ]
    }

    func loadReviews(clinicId: Int, reset: Bool = false) async {
        if reset {
            reviews = []
            reviewsPage = 1
            hasMoreReviews = false
        }

        do {
            isLoadingReviews = true

            let response: PaginatedResponse<ReviewDTO> = try await APIClient.shared.request(
                endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/reviews/?page=\(reviewsPage)",
                method: "GET",
                body: nil,
                requiresAuth: true
            )

            let newReviews = response.results.map { dto in
                ReviewUIModel(
                    id: dto.id,
                    authorName: "Пользователь \(dto.author)",
                    text: dto.text,
                    score: dto.score,
                    date: ""
                )
            }

            reviews.append(contentsOf: newReviews)
            hasMoreReviews = response.next != nil
            reviewsPage += 1
            isLoadingReviews = false

        } catch {
            isLoadingReviews = false
            errorMessage = error.localizedDescription
        }
    }

    func loadVets(clinicId: Int) async {
        guard !isLoadingVets else { return }

        do {
            isLoadingVets = true

            let dtos = try await getVetsUseCase.execute(clinicId: clinicId)

            specialists = dtos.map { dto in
                SpecialistUIModel(
                    id: dto.id,
                    name: dto.full_name,
                    specialization: dto.specialization ?? "Ветеринар",
                    experience: "",
                    imageURL: dto.avatar,
                    bio: dto.bio,
                    phone: dto.phone,
                    email: dto.email
                )
            }

            isLoadingVets = false

        } catch {
            isLoadingVets = false
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
