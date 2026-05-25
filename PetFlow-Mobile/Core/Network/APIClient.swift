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
            
        case 403:
            throw APIError.forbidden
            
        default:
            throw APIError.serverError("Ошибка сервера")
        }
        
        do {
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            return try decoder.decode(T.self, from: data)
            
        } catch {
            
            print(error)
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            throw APIError.decodingError
        }
    }
    
    func uploadMultipart<T: Decodable>(
        endpoint: String,
        method: String,
        fields: [String: String],
        imageData: Data?,
        imageFieldName: String,
        requiresAuth: Bool
    ) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        if requiresAuth,
           let token = TokenStorage.shared.accessToken {
            
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        var body = Data()
        
        for (key, value) in fields {
            
            body.append("--\(boundary)\r\n")
            body.append(
                "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            )
            body.append("\(value)\r\n")
        }
        
        if let imageData {
            
            body.append("--\(boundary)\r\n")
            
            body.append(
                "Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"avatar.jpg\"\r\n"
            )
            
            body.append("Content-Type: image/jpeg\r\n\r\n")
            
            body.append(imageData)
            
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard 200...299 ~= response.statusCode else {
            let responseBody = String(data: data, encoding: .utf8) ?? "<empty body>"
            
            print("PATCH \(endpoint) failed with status: \(response.statusCode)")
            print("Response body: \(responseBody)")
            
            switch response.statusCode {
            case 401:
                throw APIError.unauthorized
            case 403:
                throw APIError.forbidden
            default:
                throw APIError.serverError(responseBody)
            }
        }
        
        return try decoder.decode(T.self, from: data)
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
