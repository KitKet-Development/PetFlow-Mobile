//
//  ClinicCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//

import SwiftUI

struct ClinicCard: View {

    let clinic: ClinicDTO
    let onBook: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            AsyncImage(url: URL(string: clinic.logo ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholder
                default:
                    placeholder
                }
            }
            .frame(height: 180)
            .clipped()
            .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 12) {

                HStack(alignment: .top) {

                    Text(clinic.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    if let rating = clinic.rating {
                        Text("★ \(rating, specifier: "%.1f")")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#4A37A7"))
                    }
                }

                if let description = clinic.description {
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }

                if let address = clinic.address?.full_address {
                    Label(address, systemImage: "mappin.and.ellipse")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                if let phone = clinic.phone {
                    Label(phone, systemImage: "phone")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                PrimaryButton(
                    title: "Записаться",
                    isSecondary: false,
                    action: onBook
                )
                .buttonStyle(.plain)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(
            color: .black.opacity(0.05),
            radius: 10,
            x: 0,
            y: 5
        )
    }

    // MARK: - Placeholder
    private var placeholder: some View {
        Rectangle()
            .fill(Color(hex: "#E8E3FF"))
            .overlay(
                Image(systemName: "building.2")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "#4A37A7").opacity(0.4))
            )
    }
}
