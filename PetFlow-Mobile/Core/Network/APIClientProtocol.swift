//
//  APIClientProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

protocol APIClientProtocol {

    func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Encodable?,
        requiresAuth: Bool
    ) async throws -> T
}
