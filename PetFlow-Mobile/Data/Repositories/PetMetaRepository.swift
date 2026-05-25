//
//  PetMetaRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

import Foundation

final class PetMetaRepository: PetMetaRepositoryProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getSpecies() async throws -> [SpeciesDTO] {
        
        let response: PaginatedResponse<SpeciesDTO> =
        try await apiClient.request(
            endpoint: APIConfig.shared.speciesURL,
            method: "GET",
            body: nil,
            requiresAuth: false
        )
        
        return response.results
    }
    
    func getBreeds() async throws -> [BreedDTO] {
        
        let response: PaginatedResponse<BreedDTO> =
        try await apiClient.request(
            endpoint: APIConfig.shared.breedsURL,
            method: "GET",
            body: nil,
            requiresAuth: false
        )
        
        return response.results
    }
}
