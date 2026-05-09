//
//  WelcomeView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var showRegistration = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(WelcomeViewImages.logo)
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                    Text(WelcomeViewStrings.welcomeTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    
                    Text(WelcomeViewStrings.welcomeSubtitle)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .foregroundColor(.gray)
                }
                
                Image(WelcomeViewImages.welcomeIllustration)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
                
                Spacer()
                
                VStack(spacing: 12) {
                    PrimaryButton(title: WelcomeViewStrings.registration, isSecondary: false) {
                        showRegistration = true
                    }
                    
                    PrimaryButton(title: WelcomeViewStrings.login, isSecondary: true) {
                        viewModel.onLoginTap()
                    }
                }
                .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    Text(WelcomeViewStrings.termsAgreement)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 8) {
                        Image(systemName: WelcomeViewImages.shieldIcon)
                        Text(WelcomeViewStrings.dataProtection)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#4A4A4A"))
                }
                .padding(.bottom, 20)
            }
            .background(Color(hex: "#F8F9FE").ignoresSafeArea())
            .navigationDestination(isPresented: $showRegistration) {
                RegistrationView()
            }
        }
        
    }
}

