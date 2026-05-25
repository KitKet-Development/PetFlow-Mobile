//
//  BookingRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct BookingRow: View {
    let booking: BookingMock
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#E8E3FF"))
                    .frame(width: 48, height: 48)
                Image(systemName: booking.icon)
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.type)
                    .font(.system(size: 16, weight: .bold))
                Text("\(booking.petName) • \(booking.date)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(booking.time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(booking.status)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(booking.status == "Скоро" ? Color(hex: "#E8E3FF") : Color.clear)
                .foregroundColor(booking.status == "Скоро" ? Color(hex: "#4A37A7") : .gray)
                .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}
