//
//  FilterChip.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//

import SwiftUI

struct FilterChip: View {

    let title: String
    var icon: String? = nil

    let isSelected: Bool

    var body: some View {

        HStack {

            if let icon {
                Image(systemName: icon)
            }

            Text(title)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            isSelected
            ? Color(hex: "#4A37A7")
            : Color(hex: "#E8EFFF")
        )
        .foregroundColor(
            isSelected
            ? .white
            : .black
        )
        .cornerRadius(20)
    }
}
