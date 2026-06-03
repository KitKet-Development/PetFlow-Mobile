//
//  RegistrationView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 09.05.2026.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var navigateToAddPet = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: RegistrationViewImages.backIcon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                
                Color.clear.frame(width: 20, height: 20)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .frame(height: 4)
                Rectangle()
                    .fill(Color(hex: "#4A37A7"))
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: 4)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    VStack(spacing: 8) {
                        Text(RegistrationViewStrings.registrationTitle)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.gray)
                        Text(RegistrationViewStrings.registrationSubtitle)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(
                            label: RegistrationViewStrings.firstName,
                            placeholder: RegistrationViewStrings.placeholderName,
                            text: $viewModel.firstName,
                            
                        )
                        CustomTextField(
                            label: RegistrationViewStrings.lastName,
                            placeholder: RegistrationViewStrings.placeholderLastName,
                            text: $viewModel.lastName,
                            
                        )
                        CustomTextField(
                            label: RegistrationViewStrings.email,
                            placeholder: RegistrationViewStrings.placeholderEmail,
                            text: $viewModel.email,
                            keyboardType: .emailAddress,
                            
                        )
                        CustomTextField(
                            label: RegistrationViewStrings.password,
                            placeholder: "••••••••",
                            text: $viewModel.password,
                            isSecure: true,
                            
                        )
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                    Image(RegistrationViewImages.avatarPlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        PrimaryButton(title: RegistrationViewStrings.finishRegistration, isSecondary: false) {
                            Task {
                                viewModel.finishRegistration()
                            }
                        }
                        .onChange(of: viewModel.registrationSuccess) { _, success in
                            
                            if success {
                                navigateToAddPet = true
                            }
                        }
                        
                        Text(RegistrationViewStrings.termsFullAgreement)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationDestination(isPresented: $navigateToAddPet) {
                AddPetView()
            }
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
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
