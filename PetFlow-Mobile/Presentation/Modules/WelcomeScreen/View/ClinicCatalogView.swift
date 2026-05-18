//
//  ClinicCatalogView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 12.05.2026.
//

import SwiftUI

struct ClinicCatalogView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Все"
    @State private var selectedClinic: ClinicDTO? = nil
    @StateObject private var viewModel = ClinicCatalogViewModel()
    
    let allClinics = [
        Clinic(name: "ЗооЦентр «Пушистики»", address: "ул. Ленина, 45", distance: "1.2 км", rating: "4.9", price: "₽₽", category: "Кошки", description: "Лучшая клиника для ваших котиков с современным оборудованием.", phone: "+7 (999) 123-45-67", workingHours: "09:00 - 21:00", imageName: "clinic_1"),
        Clinic(name: "Вет-Клиника «Альфа»", address: "пр. Мира, 12", distance: "2.8 км", rating: "4.7", price: "₽₽₽", category: "Собаки", description: "Специализируемся на крупных породах собак и хирургии.", phone: "+7 (999) 888-77-66", workingHours: "Круглосуточно", imageName: "clinic_2")
    ]
    
    var filteredClinics: [Clinic] {
        allClinics.filter { clinic in
            let matchCategory = (selectedFilter == "Все" || clinic.category == selectedFilter)
            let matchSearch = searchText.isEmpty || clinic.name.lowercased().contains(searchText.lowercased())
            return matchCategory && matchSearch
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chevron.left")
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Image("UserAvatar")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: ClinicCatalogViewImages.searchIcon)
                    .foregroundColor(.gray)
                TextField(ClinicCatalogViewString.searchPlaceholder, text: $searchText)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0E0E0")))
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FilterChip(title: "Все", icon: ClinicCatalogViewImages.filterIcon, isSelected: selectedFilter == "Все")
                        .onTapGesture { selectedFilter = "Все" }
                    
                    ForEach(["Кошки", "Собаки", "Рядом"], id: \.self) { cat in
                        FilterChip(title: cat, isSelected: selectedFilter == cat)
                            .onTapGesture { selectedFilter = cat }
                    }
                }
                .padding(.horizontal)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.clinics) { clinic in
                        ClinicCard(
                            name: clinic.name,
                        )
                        .onTapGesture {
                            selectedClinic = clinic
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(hex: "#F8F9FE"))
        .onAppear {
            viewModel.fetchClinics()
        }
    }
}

struct ClinicCard: View {
    let name: String
    let address: String = ""
    let distance: String = ""
    let rating: String = ""
    let price: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color(hex: "#E8E3FF"))
                    .frame(height: 180)
                
                Text("★ \(rating)")
                    .font(.system(size: 14, weight: .bold))
                    .padding(6)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(name)
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Text(price)
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("\(distance) • \(address)")
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
                
                PrimaryButton(title: "Записаться", isSecondary: false) {
                    // Action
                }
                .frame(height: 44)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if let icon = icon { Image(systemName: icon) }
            Text(title)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? Color(hex: "#4A37A7") : Color(hex: "#E8EFFF"))
        .foregroundColor(isSelected ? .white : .black)
        .cornerRadius(20)
    }
}

