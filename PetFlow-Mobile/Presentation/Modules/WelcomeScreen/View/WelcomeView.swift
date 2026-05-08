//
//  WelcomeView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            VStack(spacing: 12) {
                Image(AppImages.logo)
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Text(AppStrings.welcomeTitle)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(Color(hex: "#1A1A1A"))
                
                Text(AppStrings.welcomeSubtitle)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Image(AppImages.welcomeIllustration)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: AppStrings.registration, isSecondary: false) {
                    viewModel.onRegistrationTap()
                }
                
                PrimaryButton(title: AppStrings.login, isSecondary: true) {
                    viewModel.onLoginTap()
                }
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                Text(AppStrings.termsAgreement)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 8) {
                    Image(systemName: AppImages.shieldIcon)
                    Text(AppStrings.dataProtection)
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#4A4A4A"))
            }
            .padding(.bottom, 20)
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
    }
}
