//
//  APIClient.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        requiresAuth: Bool
    ) async throws -> T
}

final class APIClient: APIClientProtocol {

    private let tokenStorage: TokenStorageProtocol

    init(tokenStorage: TokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {

        guard let url = URL(string: APIConfig.baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth,
           let token = tokenStorage.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break

        case 401:
            throw NetworkError.unauthorized

        default:
            throw NetworkError.serverError("Ошибка: \(httpResponse.statusCode)")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        encodeClosure = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
