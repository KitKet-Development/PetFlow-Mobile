//
//  TokenStorage.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol TokenStorageProtocol {
    func saveAccessToken(_ token: String)
    func getAccessToken() -> String?
    func clear()
}

final class TokenStorage: TokenStorageProtocol {

    private let tokenKey = "access_token"

    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func getAccessToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
