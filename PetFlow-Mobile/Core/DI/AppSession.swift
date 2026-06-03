//
//  AppSession.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 17.05.2026.
//

import Foundation
import Combine
 
final class AppSession: ObservableObject {
 
    static let shared = AppSession()
 
    @Published var isLoggedIn: Bool = false
    @Published var userRole: UserRole = .user
 
    private init() {
        if let token = TokenStorage.shared.accessToken, !token.isEmpty {
            isLoggedIn = true
            let roleRaw = UserDefaults.standard.string(forKey: "user_role") ?? "user"
            userRole = UserRole(rawValue: roleRaw) ?? .user
        }
    }
 
    func login(role: String) {
        let resolvedRole = UserRole(rawValue: role) ?? .user
        userRole = resolvedRole
        UserDefaults.standard.set(role, forKey: "user_role")
        isLoggedIn = true
    }
 
    func logout() {
        isLoggedIn = false
        userRole = .user
        UserDefaults.standard.removeObject(forKey: "user_role")
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        TokenStorage.shared.clear()
        DependencyContainer.reset()
    }
}
