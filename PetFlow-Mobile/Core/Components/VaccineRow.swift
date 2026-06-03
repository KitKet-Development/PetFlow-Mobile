//
//  VaccineRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 17.05.2026.
//

import SwiftUI

struct VaccineRow: View {
    let title: String
    let date: String
    let expiresAt: String?
    let notes: String?
    var isDashed: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                Text(date)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                if let exp = expiresAt {
                    Text("До: \(exp)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#B07D00"))
                }
                if let notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: isDashed ? "checkmark.seal" : "checkmark.seal.fill")
                .foregroundColor(Color(hex: "#4A37A7"))
                .font(.system(size: 20))
        }
        .padding(14)
        .background(Color(hex: "#F0F4FF"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isDashed
                        ? Color(hex: "#4A37A7").opacity(0.4)
                        : Color.clear,
                    style: StrokeStyle(lineWidth: 1.5, dash: isDashed ? [5] : [])
                )
        )
    }
}
