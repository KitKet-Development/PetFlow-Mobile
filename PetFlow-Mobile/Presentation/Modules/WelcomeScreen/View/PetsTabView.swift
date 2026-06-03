//
//  PetsTabView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct PetsTabView: View {
    @State private var pets: [PetDTO] = []
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                Spacer()
                ProgressView("Загрузка...")
                Spacer()
            } else if pets.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 48))
                        .foregroundColor(Color(hex: "#4A37A7").opacity(0.3))
                    Text("Питомцы не найдены")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#F8F9FE").ignoresSafeArea())
            } else {
                TabView {
                    ForEach(pets) { pet in
                        PetDetailView(pet: pet)
                            .id(pet.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: pets.count > 1 ? .always : .never))
            }
        }
        .task {
            isLoading = true
            pets = (try? await DependencyContainer.shared.getPetsUseCase.execute()) ?? []
            isLoading = false
        }
    }
}
