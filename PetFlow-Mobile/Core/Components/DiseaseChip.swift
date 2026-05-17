//
//  DiseaseChip.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 17.05.2026.
//

import SwiftUI

struct DiseaseChip: View {
    let title: String
    let color: Color
    let textColor: Color
    let icon: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.system(size: 13, weight: .medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color)
        .foregroundColor(textColor)
        .cornerRadius(20)
    }
}
