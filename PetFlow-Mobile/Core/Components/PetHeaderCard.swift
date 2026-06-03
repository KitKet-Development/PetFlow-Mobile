//
//  PetHeaderCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct PetHeaderCard: View {
    let pet: PetDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Баннер
            ZStack {
                if let str = pet.avatar, let url = URL(string: str) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img): img.resizable().scaledToFill()
                        default: bannerPlaceholder
                        }
                    }
                } else {
                    bannerPlaceholder
                }
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(20, corners: [.topLeft, .topRight])

            // Аватар + инфо
            HStack(alignment: .bottom, spacing: 16) {
                avatarView
                    .offset(y: -30)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(pet.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    if let breed = pet.breed?.name {
                        Text(breed)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Text(pet.species.name)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 12)

                Spacer()
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    }

    private var bannerPlaceholder: some View {
        Color(hex: "#E8EFFF")
            .overlay(
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "#4A37A7").opacity(0.2))
            )
    }

    private var avatarView: some View {
        ZStack {
            if let str = pet.avatar, let url = URL(string: str) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Color(hex: "#E8EFFF")
                    }
                }
            } else {
                Color(hex: "#E8EFFF")
                Image(systemName: "pawprint.fill")
                    .foregroundColor(Color(hex: "#4A37A7").opacity(0.4))
            }
        }
        .frame(width: 90, height: 90)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 3)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

