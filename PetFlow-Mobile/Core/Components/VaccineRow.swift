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
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 15, weight: .semibold))
                Text(date).font(.system(size: 13)).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: PetDetailViewImages.checkmarkIcon)
                .foregroundColor(Color(hex: "#4A37A7"))
        }
        .padding()
        .background(Color(hex: "#F0F4FF"))
        .cornerRadius(12)
    }
}
