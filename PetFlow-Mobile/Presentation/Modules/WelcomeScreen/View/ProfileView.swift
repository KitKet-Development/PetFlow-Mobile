//
//  ProfileView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct ProfilePetUIModel: Identifiable {

    let id: Int
    let name: String
    let species: String
    let breed: String
    let imageURL: String?
}

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ProfileViewModel.makeDefault()
    @State private var showLogoutAlert = false
    
    
    @State private var isEditingProfile = false
    @State private var isNavigateToNotifications = false
    
    var body: some View {
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
                        
                        if let avatarURL = viewModel.avatarURL,
                           let url = URL(string: avatarURL) {

                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()

                            } placeholder: {

                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())

                        } else {

                            Image(ProfileViewImages.userPhoto)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        
                        Text(viewModel.fullName)
                            .font(.system(size: 22, weight: .bold))

                        Text(viewModel.email)
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
                                    PetCardLocal(pet: pet)
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
                        Button(action: { isNavigateToNotifications = true}){
                            MenuRow(title: ProfileViewString.notifications, icon: ProfileViewImages.bellIcon)
                        }
                        Button {
                            showLogoutAlert = true
                        } label: {
                            MenuRow(title: ProfileViewString.logout, icon: ProfileViewImages.logoutIcon,isDestructive: true)
                        }
                    }
                    .alert("Выйти?", isPresented: $showLogoutAlert) {
                        
                        Button("Да", role: .destructive) {
                            dismiss()
                        }
                        
                        Button("Отмена", role: .cancel) {}
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationDestination(isPresented: $isEditingProfile) {
            ProfileViewEditing(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $isNavigateToNotifications) {
            NotificationSettingsView()
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadProfile()
            }
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

                } else {

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

