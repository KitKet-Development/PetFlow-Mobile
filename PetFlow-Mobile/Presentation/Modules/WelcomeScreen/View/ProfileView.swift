//
//  ProfileView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                HStack {
                    Text(WelcomeViewStrings.welcomeTitle)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#4A37A7"))
                    Spacer()
                    Image(systemName: ProfileViewImages.menuIcon)
                        .font(.system(size: 20))
                }
                .padding()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(spacing: 12) {
                            Image(ProfileViewImages.userPhoto)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            
                            Text(viewModel.userName)
                                .font(.system(size: 22, weight: .bold))
                            
                            Text(viewModel.userEmail)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(ProfileViewString.myPets)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                                Image(systemName: ProfileViewImages.plusIcon)
                                    .foregroundColor(Color(hex: "#4A37A7"))
                                    .font(.system(size: 20))
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.pets) { pet in
                                        PetCard(pet: pet)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(ProfileViewString.bookingHistory)
                                .font(.system(size: 18, weight: .bold))
                            
                            ForEach(viewModel.bookings) { booking in
                                BookingRow(booking: booking)
                            }
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: { isEditingProfile = true }) {
                                MenuRow(title: ProfileViewString.editProfile, icon: ProfileViewImages.editIcon)
                            }
                            MenuRow(title: ProfileViewString.notifications, icon: ProfileViewImages.bellIcon)
                            MenuRow(title: ProfileViewString.logout, icon: ProfileViewImages.logoutIcon, isDestructive: true)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(isPresented: $isEditingProfile) {
                ProfileViewEditing()
            }
            .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        }
    }
}

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

struct BookingRow: View {
    let booking: BookingMock
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#E8E3FF"))
                    .frame(width: 48, height: 48)
                Image(systemName: booking.icon)
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.type)
                    .font(.system(size: 16, weight: .bold))
                Text("\(booking.petName) • \(booking.date)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(booking.time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(booking.status)
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(booking.status == "Скоро" ? Color(hex: "#E8E3FF") : Color.clear)
                .foregroundColor(booking.status == "Скоро" ? Color(hex: "#4A37A7") : .gray)
                .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}

struct MenuRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? Color(hex: "#C9554D") : Color(hex: "#4A37A7"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isDestructive ? Color(hex: "#C9554D") : .black)
            
            Spacer()
            
            if !isDestructive {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(isDestructive ? Color(hex: "#EEF2FF") : Color(hex: "#EEF2FF"))
        .cornerRadius(12)
    }
}
