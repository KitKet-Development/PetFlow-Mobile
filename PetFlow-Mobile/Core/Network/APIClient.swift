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
            
        } catch let DecodingError.typeMismatch(type, context) {
            
            print("TYPE MISMATCH")
            print(type)
            print(context.codingPath)
            print(context.debugDescription)
            
            throw DecodingError.typeMismatch(type, context)
            
        } catch let DecodingError.valueNotFound(type, context) {
            
            print("VALUE NOT FOUND")
            print(type)
            print(context.codingPath)
            print(context.debugDescription)
            
            throw DecodingError.valueNotFound(type, context)
            
        } catch let DecodingError.keyNotFound(key, context) {
            
            print("KEY NOT FOUND")
            print(key)
            print(context.codingPath)
            print(context.debugDescription)
            
            throw DecodingError.keyNotFound(key, context)
            
        } catch let DecodingError.dataCorrupted(context) {
            
            print("DATA CORRUPTED")
            print(context.codingPath)
            print(context.debugDescription)
            
            throw DecodingError.dataCorrupted(context)
            
        } catch {
            
            print(error)
            
            throw error
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
            print("📸 Добавляем фото в multipart: \(imageData.count) bytes")
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"avatar.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        } else {
            print("❌ imageData nil — фото не добавлено в запрос")
        }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("📡 Статус ответа: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        print("📡 Ответ сервера: \(String(data: data, encoding: .utf8) ?? "пусто")")
        
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
    
    func requestNoContent(
        endpoint: String,
        method: String = "DELETE",
        requiresAuth: Bool = false
    ) async throws {
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth, let token = TokenStorage.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299: break
        case 401: throw APIError.unauthorized
        case 403: throw APIError.forbidden
        default: throw APIError.serverError("Ошибка сервера: \(httpResponse.statusCode)")
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
