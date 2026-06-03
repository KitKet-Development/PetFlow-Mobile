//
//  PetCardLocal.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 25.05.2026.
//

import SwiftUI

struct PetCardLocal: View {
    
    let pet: ProfilePetUIModel
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Group {
                
                if let imageURL = pet.imageURL,
                   let url = URL(string: imageURL) {
                    
                    AsyncImage(url: url) { phase in
                        
                        switch phase {
                            
                        case .success(let image):
                            
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure(_):
                            
                            Image("PetPhotoPlaceholder")
                                .resizable()
                                .scaledToFill()
                            
                        case .empty:
                            
                            ZStack {
                                
                                Color.gray.opacity(0.08)
                                
                                ProgressView()
                            }
                            
                        @unknown default:
                            
                            Image("PetPhotoPlaceholder")
                                .resizable()
                                .scaledToFill()
                        }
                        
                    }
                    
                }else {
                    
                    Image("PetPhotoPlaceholder")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(spacing: 4) {
                
                Text(pet.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(pet.species)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                if !pet.breed.isEmpty {
                    
                    Text(pet.breed)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#4A37A7"))
                        .lineLimit(1)
                }
            }
        }
        .frame(width: 124)
        .padding(12)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.04),
            radius: 6,
            x: 0,
            y: 2
        )
    }
}
