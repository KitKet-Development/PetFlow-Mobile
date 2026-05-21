//
//  WelcomeView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel(tokenStorage: TokenStorage.shared)
    @State private var showRegistration = false
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#EDE8F5").ignoresSafeArea()

                    // Верхняя волна
                    VStack {
                        WaveTopShape()
                            .fill(Color(hex: "#C9BFF0"))
                            .frame(height: geometry.size.height * 0.38)
                        Spacer()
                    }
                    .ignoresSafeArea()

                    // Нижняя волна
                    VStack {
                        Spacer()
                        WaveBottomShape()
                            .fill(Color(hex: "#C9BFF0"))
                            .frame(height: geometry.size.height * 0.32)
                    }
                    .ignoresSafeArea()

                    // Основной контент
                    VStack(spacing: 0) {
                        Spacer()

                        // Лого + название
                        VStack(spacing: 14) {
                            Image(WelcomeViewImages.logo)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(20)

                            Text(WelcomeViewStrings.welcomeTitle)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color(hex: "#1A1A1A"))
                        }
                        .offset(y: -geometry.size.height * 0.1)


                        // Кнопки + соглашение
                        VStack(spacing: 14) {
                            PrimaryButton(
                                title: WelcomeViewStrings.registration,
                                isSecondary: false
                            ) {
                                showRegistration = true
                            }

                            PrimaryButton(
                                title: WelcomeViewStrings.login,
                                isSecondary: true
                            ) {
                                showLogin = true
                            }

                            Text(WelcomeViewStrings.termsAgreement)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                        }
                        .padding(.horizontal, 24)
                        .offset(y: -geometry.size.height * 0.05) // ← чуть выше нижней части

                        Spacer()

                        // Защита данных — самый низ
                        HStack(spacing: 8) {
                            Image(systemName: WelcomeViewImages.shieldIcon)
                            Text(WelcomeViewStrings.dataProtection)
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#4A4A4A"))
                        .padding(.bottom, geometry.size.height * 0.03)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .navigationDestination(isPresented: $showRegistration) {
                    RegistrationView()
                }
                .navigationDestination(isPresented: $showLogin) {
                    LoginView()
                }
            }
        }
    }
}

// Верхняя волна — выпуклая вниз
struct WaveTopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.75))
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height * 0.75),
            control1: CGPoint(x: rect.width * 0.8, y: rect.height * 1.15),
            control2: CGPoint(x: rect.width * 0.2, y: rect.height * 0.4)
        )
        path.closeSubpath()
        return path
    }
}

// Нижняя волна — вогнутая вверх
struct WaveBottomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.25))
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height * 0.25),
            control1: CGPoint(x: rect.width * 0.8, y: rect.height * 0.6),
            control2: CGPoint(x: rect.width * 0.2, y: -rect.height * 0.1)
        )
        path.closeSubpath()
        return path
    }
}
