//
//  InfoRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(hex: "#4A37A7"))
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
}
