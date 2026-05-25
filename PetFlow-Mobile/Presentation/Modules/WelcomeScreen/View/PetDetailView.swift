//
//  PetDetailView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct PetDetailView: View {
    @StateObject private var viewModel = PetDetailViewModel()
    @StateObject private var storage = LocalStorageService.shared
    
    var firstPet: LocalPet? {
        storage.pets.first
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Image(ProfileViewImages.userPhoto)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
            .padding()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 0) {
                        Image("dog_large")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack(alignment: .bottom) {
                            Image("dog_thumb")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 3))
                                .offset(y: -30)
                                .padding(.leading, 16)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(firstPet?.name ?? "Питомец отсутствует")
                                    Image(systemName: "pencil").font(.system(size: 14))
                                }
                                Text(firstPet?.type ?? "")
                            }
                            .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Label(PetDetailViewString.chronicDiseases, systemImage: PetDetailViewImages.diseaseIcon)
                            .font(.system(size: 18, weight: .bold))
                        
                        FlowLayout(spacing: 8) {
                            DiseaseChip(title: "Пищевая аллергия", color: Color(hex: "#FFEBEC"), textColor: Color(hex: "#C9554D"), icon: "exclamationmark.circle")
                            DiseaseChip(title: "Чувствительное пищеварение", color: Color(hex: "#F0F4FF"), textColor: Color(hex: "#4A37A7"), icon: "leaf")
                        }
                        
                        Text("Рекомендована диета: Royal Canin Hypoallergenic. Избегать курицы и кукурузы.")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Label(PetDetailViewString.vaccinations, systemImage: "ivfluid.bag.fill")
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text(PetDetailViewString.totalVaccinations).font(.system(size: 14)).foregroundColor(.gray)
                        }
                        
                        VaccineRow(title: "Бешенство (Rabies)", date: "15 Июл 2023")
                        VaccineRow(title: "Комплексная (DHPP)", date: "12 Май 2023")
                        
                        Button(PetDetailViewString.showAllVaccinations) { }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Label(PetDetailViewString.healthHistory, systemImage: PetDetailViewImages.historyIcon)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Image(systemName: "plus.circle").foregroundColor(Color(hex: "#4A37A7"))
                        }
                        
                        ForEach(viewModel.healthRecords) { record in
                            TimelineRow(record: record)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
    }
}
