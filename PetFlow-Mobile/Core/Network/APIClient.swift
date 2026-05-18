//
//  APIClient.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

final class APIClient: APIClientProtocol {

    static let shared = APIClient()

    private init() {}

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {

        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth,
           let token = TokenStorage.shared.accessToken {

            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        if let body {
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {

        case 200...299:
            break

        case 401:
            throw APIError.unauthorized

        default:
            throw APIError.serverError("Ошибка сервера")
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
}

struct AnyEncodable: Encodable {

    private let encodeFunc: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        encodeFunc = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
