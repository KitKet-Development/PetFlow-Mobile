//
//  PrimaryButton.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isSecondary: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isSecondary ? Color.clear : Color(hex: "#4A37A7"))
                .foregroundColor(isSecondary ? Color(hex: "#4A37A7") : .white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSecondary ? Color(hex: "#D1D1D1") : Color.clear, lineWidth: 1)
                )
        }
    }
}
