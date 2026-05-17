//
//  AppSession.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 17.05.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AppSession: ObservableObject {

    static let shared = AppSession()

    @Published var currentUser: LocalUser?
    @Published var pets: [LocalPet] = []
    @Published var isAuthorized = false

    private init() {}

    func logout() {
        currentUser = nil
        pets = []
        isAuthorized = false
    }
}

struct LocalUser {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var phone: String = ""
    var avatar: UIImage?
}

struct LocalPet: Identifiable {
    let id = UUID()

    var name: String
    var type: String
    var image: UIImage?
}


final class LocalStorageService: ObservableObject {

    static let shared = LocalStorageService()

    @Published var currentUser: LocalUser?
    @Published var pets: [LocalPet] = []

    private init() {}
}
