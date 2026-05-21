//
//  ClinicRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class ClinicRepository: ClinicRepositoryProtocol {

    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient.shared) {
        self.client = client
    }

    func getClinics(filters: ClinicFilterParams = ClinicFilterParams()) async throws -> [ClinicDTO] {

        var components = URLComponents(
            string: "\(APIConfig.shared.baseURL)/clinics/"
        )!

        var queryItems: [URLQueryItem] = []

        if let minRating = filters.minRating {
            queryItems.append(URLQueryItem(name: "min_rating", value: "\(minRating)"))
        }
        if let species = filters.species {
            queryItems.append(URLQueryItem(name: "species", value: "\(species)"))
        }
        if let city = filters.city {
            queryItems.append(URLQueryItem(name: "city", value: city))
        }
        if let search = filters.search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        let endpoint = components.url?.absoluteString ?? "\(APIConfig.shared.baseURL)/clinics/"

        let response: PaginatedResponse<ClinicDTO> = try await client.request(
            endpoint: endpoint,
            method: "GET",
            body: nil,
            requiresAuth: false
        )

        return response.results
    }
    
    func getSlots(clinicId: Int) async throws -> [SlotDTO] {
        let response: PaginatedResponse<SlotDTO> = try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/clinics/\(clinicId)/slots/",
            method: "GET",
            body: nil,
            requiresAuth: true
        )
        return response.results
    }
}
