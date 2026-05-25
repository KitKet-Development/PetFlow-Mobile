//
//  DateCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct DateCard: View {
    let day: String
    let date: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(day).font(.system(size: 12))
                Text(date).font(.system(size: 18, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color(hex: "#4A37A7") : Color.white)
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
    }
}
