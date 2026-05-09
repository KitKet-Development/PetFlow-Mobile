//
//  CustomTextField.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 09.05.2026.
//

import SwiftUI

struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            Group {
                if isSecure {
                    HStack {
                        SecureField(placeholder, text: $text)
                        Image(systemName: RegistrationViewImages.eyeIcon)
                            .foregroundColor(.gray)
                    }
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#D1D1D1"), lineWidth: 1)
            )
        }
    }
}
