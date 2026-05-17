//
//  NetworkError.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

enum NetworkError: LocalizedError {
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
            return "Необходима авторизация"
        case .decodingError:
            return "Ошибка декодирования"
        case .serverError(let message):
            return message
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
