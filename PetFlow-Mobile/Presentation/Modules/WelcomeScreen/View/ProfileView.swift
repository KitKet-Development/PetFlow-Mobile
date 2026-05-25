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



