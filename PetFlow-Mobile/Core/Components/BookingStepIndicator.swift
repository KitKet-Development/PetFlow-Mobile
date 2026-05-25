//
//  BookingStepIndicator.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct BookingStepIndicator: View {
    let currentStep: Int
    var body: some View {
        HStack {
            StepCircle(number: "1", title: "ВРЕМЯ", isActive: currentStep >= 1)
            Line()
            StepCircle(number: "2", title: "ПИТОМЕЦ", isActive: currentStep >= 2)
            Line()
            StepCircle(number: "3", title: "ИНФО", isActive: currentStep >= 3)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func StepCircle(number: String, title: String, isActive: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isActive ? Color(hex: "#4A37A7") : Color(hex: "#E8EFFF"))
                    .frame(width: 30, height: 30)
                Text(number)
                    .foregroundColor(isActive ? .white : .gray)
                    .font(.system(size: 14, weight: .bold))
            }
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(isActive ? .black : .gray)
        }
    }
    
    @ViewBuilder
    func Line() -> some View {
        Rectangle()
            .fill(Color(hex: "#E8EFFF"))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
    }
}
