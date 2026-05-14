//
//  PetDetailView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct PetDetailView: View {
    @StateObject private var viewModel = PetDetailViewModel()
    
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
                                    Text(viewModel.petName).font(.system(size: 20, weight: .bold))
                                    Image(systemName: "pencil").font(.system(size: 14))
                                }
                                Text(viewModel.breed).font(.system(size: 14)).foregroundColor(.gray)
                                Text(viewModel.age).font(.system(size: 14)).foregroundColor(.gray)
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
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
    }
}


struct DiseaseChip: View {
    let title: String
    let color: Color
    let textColor: Color
    let icon: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.system(size: 13, weight: .medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color)
        .foregroundColor(textColor)
        .cornerRadius(20)
    }
}

struct VaccineRow: View {
    let title: String
    let date: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 15, weight: .semibold))
                Text(date).font(.system(size: 13)).foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: PetDetailViewImages.checkmarkIcon)
                .foregroundColor(Color(hex: "#4A37A7"))
        }
        .padding()
        .background(Color(hex: "#F0F4FF"))
        .cornerRadius(12)
    }
}

struct TimelineRow: View {
    let record: HealthRecord
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: "#4A37A7"))
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(record.date)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#E8E3FF"))
                    .foregroundColor(Color(hex: "#4A37A7"))
                    .cornerRadius(8)
                
                Text(record.title).font(.system(size: 16, weight: .bold))
                
                if let doc = record.doctor {
                    Text("Терапевт: \(doc)").font(.system(size: 13)).foregroundColor(.gray)
                }
                
                Text(record.description).font(.system(size: 13)).foregroundColor(.gray)
                
                if let file = record.fileName {
                    HStack {
                        Image(systemName: PetDetailViewImages.paperclipIcon)
                        Text(file)
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 20)
        }
    }
}
