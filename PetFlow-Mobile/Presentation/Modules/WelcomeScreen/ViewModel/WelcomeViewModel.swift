//
//  WelcomeViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import Foundation
import Combine

@MainActor
final class WelcomeViewModel: ObservableObject {

    @Published var isAuthorized = false
    @Published var isLoading = false

    private let tokenStorage: TokenStorageProtocol

    init(
        tokenStorage: TokenStorageProtocol = AppContainer.shared.tokenStorage
    ) {
        self.tokenStorage = tokenStorage
        checkAuth()
    }

    func checkAuth() {
        isAuthorized = tokenStorage.getAccessToken() != nil
    }

    func onRegistrationTap() {
        print("Open registration")
    }

    func onLoginTap() {
        print("Open login")
    }
}
