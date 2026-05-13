//
//  ClinicCatalogView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 12.05.2026.
//

import SwiftUI

struct ClinicCatalogView: View {
    @State private var searchText = ""
    
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
                    FilterChip(title: ClinicCatalogViewString.filterAll, icon: ClinicCatalogViewImages.filterIcon, isSelected: true)
                    FilterChip(title: "Кошки", isSelected: false)
                    FilterChip(title: "Собаки", isSelected: false)
                    FilterChip(title: "Рядом", isSelected: false)
                }
                .padding(.horizontal)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    ClinicCard(name: "ЗооЦентр «Пушистики»", address: "ул. Ленина, 45", distance: "1.2 км", rating: "4.9", price: "₽₽")
                    ClinicCard(name: "Вет-Клиника «Альфа»", address: "пр. Мира, 12", distance: "2.8 км", rating: "4.7", price: "₽₽₽")
                }
                .padding()
            }
        }
        .background(Color(hex: "#F8F9FE"))
    }
}

struct ClinicCard: View {
    let name: String
    let address: String
    let distance: String
    let rating: String
    let price: String
    
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
