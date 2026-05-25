//
//  LoginView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: RegistrationViewImages.backIcon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                
                Spacer()
                
                Color.clear
                    .frame(width: 20, height: 20)
            }
            .padding()
            
            Spacer()
            
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    
                    Text("Вход")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Войдите в ваш аккаунт")
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 16) {
                    
                    CustomTextField(
                        label: "Email",
                        placeholder: "example@mail.ru",
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )
                    
                    CustomTextField(
                        label: "Пароль",
                        placeholder: "••••••••",
                        text: $viewModel.password,
                        isSecure: true
                    )
                }
                
                PrimaryButton(
                    title: viewModel.isLoading ? "Загрузка..." : "Войти",
                    isSecondary: false
                ) {
                    viewModel.login()
                }
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .navigationDestination(isPresented: $viewModel.loginSuccess) {
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .navigationBarHidden(true)
        .alert(
            "Ошибка",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
