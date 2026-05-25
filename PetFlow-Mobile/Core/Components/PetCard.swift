//
//  PetCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct PetCard: View {
    let pet: PetMock
    var body: some View {
        VStack(spacing: 8) {
            Image(pet.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(12)
            
            Text(pet.name)
                .font(.system(size: 14, weight: .bold))
            Text(pet.breed)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5)
    }
}
