//
//  APIClientProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//
import Foundation

protocol APIClientProtocol {
    
    func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Encodable?,
        requiresAuth: Bool
    ) async throws -> T
    
    func uploadMultipart<T: Decodable>(
        endpoint: String,
        method: String,
        fields: [String: String],
        imageData: Data?,
        imageFieldName: String,
        requiresAuth: Bool
    ) async throws -> T
    
    func requestNoContent(
        endpoint: String,
        method: String,
        requiresAuth: Bool
    ) async throws
}
