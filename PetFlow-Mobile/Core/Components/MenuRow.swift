//
//  MenuRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct MenuRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? Color(hex: "#C9554D") : Color(hex: "#4A37A7"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isDestructive ? Color(hex: "#C9554D") : .black)
            
            Spacer()
            
            if !isDestructive {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(isDestructive ? Color(hex: "#EEF2FF") : Color(hex: "#EEF2FF"))
        .cornerRadius(12)
    }
}
