//
//  TokenStorage.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol TokenStorageProtocol {

    var accessToken: String? { get set }

    var refreshToken: String? { get set }

    func clear()
}

final class TokenStorage: TokenStorageProtocol {

    static let shared = TokenStorage()

    private init() {}

    private let accessTokenKey = "access_token"
    private let refreshTokenKey = "refresh_token"
    
    private let userIdKey = "user_id"

    var userId: Int? {

        get {
            UserDefaults.standard.integer(forKey: userIdKey)
        }

        set {
            UserDefaults.standard.set(newValue, forKey: userIdKey)
        }
    }

    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: accessTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: accessTokenKey)
        }
    }

    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: refreshTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: refreshTokenKey)
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: "current_user_id")
    }
}
