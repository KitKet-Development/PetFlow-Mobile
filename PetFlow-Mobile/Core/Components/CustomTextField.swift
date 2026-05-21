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
    
    var keyboardType: UIKeyboardType = .default
    
    var hasError: Bool = false
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            HStack {
                
                Group {
                    
                    if isSecure {
                        HStack {
                            Group {
                                if isPasswordVisible {
                                    TextField(placeholder, text: $text)
                                } else {
                                    SecureField(placeholder, text: $text)
                                }
                            }
                            
                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                    }
                }
            }
            .padding()
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(hasError ? Color.red : Color(hex: "#D1D1D1"), lineWidth: 1)
            )
        }
    }
}
