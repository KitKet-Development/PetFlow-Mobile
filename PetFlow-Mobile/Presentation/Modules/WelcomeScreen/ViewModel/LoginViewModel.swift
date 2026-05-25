//
//  LoginViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loginSuccess = false
    
    private let loginUseCase = DependencyContainer.shared.loginUseCase
    
    func login() {
        Task {
            await performLogin()
        }
    }
    
    private func performLogin() async {
        
        do {
            isLoading = true
            
            try await loginUseCase.execute(
                email: email,
                password: password
            )
            
            AppSession.shared.isAuthorized = true
            
            LocalStorageService.shared.currentUser = LocalUser(
                firstName: "",
                lastName: "",
                email: email,
                password: password
            )
            
            loginSuccess = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
