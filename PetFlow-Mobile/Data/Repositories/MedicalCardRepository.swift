//
//  MedicalCardRepository.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import Foundation

final class MedicalCardRepository: MedicalCardRepositoryProtocol {
    
    private let client = APIClient.shared
    
    func getMedicalCard(petId: Int) async throws -> MedicalCardDTO {
        try await client.request(
            endpoint: APIConfig.shared.medicalCardURL(petId: petId),
            method: "GET",
            body: nil,
            requiresAuth: true
        )
    }
    
    func updateMedicalCard(
        petId: Int,
        dto: MedicalCardUpdateDTO
    ) async throws -> MedicalCardDTO {
        
        try await client.request(
            endpoint: "\(APIConfig.shared.baseURL)/pets/\(petId)/medical-card/",
            method: "PATCH",
            body: dto,
            requiresAuth: true
        )
    }
    
    func downloadAttachment(petId: Int, visitId: Int) async throws -> Data {
        guard let url = URL(string: APIConfig.shared.downloadAttachmentURL(petId: petId, visitId: visitId)) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = TokenStorage.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, 200...299 ~= http.statusCode else {
            throw APIError.serverError("Ошибка загрузки файла")
        }
        return data
    }
}
