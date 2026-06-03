//
//  PetDetailView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI


struct PetDetailView: View {
    
    let pet: PetDTO
    
    @StateObject private var viewModel = PetDetailViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Image(ProfileViewImages.userPhoto)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .padding(.top, 8)
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка медкарты...")
                    .foregroundColor(.gray)
                Spacer()
                
            } else if let error = viewModel.errorMessage {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text(error).foregroundColor(.gray)
                    Button("Повторить") {
                        Task { await viewModel.loadMedicalCard(petId: pet.id) }
                    }
                    .foregroundColor(Color(hex: "#4A37A7"))
                }
                Spacer()
                
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        PetHeaderCard(pet: pet)
                        
                        if let card = viewModel.medicalCard {
                            
                            ChronicConditionsCard(
                                conditions: card.conditions,
                                allergies: card.allergies,
                                notes: card.notes,
                                viewModel: viewModel
                            )
                            
                            VaccinationsCard(vaccinations: card.vaccinations)
                            
                            VisitsCard(
                                visits: card.visits,
                                petId: pet.id,
                                viewModel: viewModel
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .task {
            await viewModel.loadMedicalCard(petId: pet.id)
        }
        .sheet(item: $viewModel.downloadedFileURL) { url in
            ShareSheet(activityItems: [url])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uvc: UIActivityViewController, context: Context) {}
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}
