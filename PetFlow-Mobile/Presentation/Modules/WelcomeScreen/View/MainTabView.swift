//
//  MainTabView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 12.05.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .catalog
    
    enum Tab {
        case catalog, pets, bookings, profile
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .catalog:
                    ClinicCatalogView()
                case .pets:
                    Text("Экран питомцев")
                case .bookings:
                    Text("Экран записей")
                case .profile:
                    Text("Экран профиля")
                }
            }
            
            HStack {
                TabItem(title: ClinicCatalogViewString.tabCatalog, icon: ClinicCatalogViewImages.tabCatalogIcon, isSelected: selectedTab == .catalog) {
                    selectedTab = .catalog
                }
                TabItem(title: ClinicCatalogViewString.tabMyPets, icon: ClinicCatalogViewImages.tabPetsIcon, isSelected: selectedTab == .pets) {
                    selectedTab = .pets
                }
                TabItem(title: ClinicCatalogViewString.tabBookings, icon: ClinicCatalogViewImages.tabBookingsIcon, isSelected: selectedTab == .bookings) {
                    selectedTab = .bookings
                }
                TabItem(title: ClinicCatalogViewString.tabProfile, icon: ClinicCatalogViewImages.tabProfileIcon, isSelected: selectedTab == .profile) {
                    selectedTab = .profile
                }
            }
            .frame(height: 70)
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
        }
    }
}

struct TabItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isSelected ? Color(hex: "4A37A7") : Color.clear)
            .cornerRadius(12)
        }
    }
}
