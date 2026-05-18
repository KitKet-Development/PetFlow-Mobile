//
//  NetworkError.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case unauthorized
    case decodingError
    case serverError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"

        case .invalidResponse:
            return "Некорректный ответ сервера"

        case .unauthorized:
            return "Ошибка авторизации"

        case .decodingError:
            return "Ошибка обработки данных"

        case .serverError(let message):
            return message

        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
