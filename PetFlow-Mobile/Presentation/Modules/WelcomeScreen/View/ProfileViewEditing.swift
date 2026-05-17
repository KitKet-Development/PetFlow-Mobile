//
//  ProfileViewEditing.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//
import SwiftUI
import Combine
import PhotosUI

struct ProfileViewEditing: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: RegistrationViewImages.backIcon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
                Spacer()
                Text(ProfileViewString.profileTitle)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Color.clear.frame(width: 20, height: 20)
            }
            .padding()
            .background(Color.white)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ZStack {
                        Image(ProfileViewImages.userPhoto)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .fill(Color.black.opacity(0.4))
                            )
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Circle()
                                .fill(Color(hex: "#4A37A7"))
                                .frame(width: 44, height: 44)
                                .overlay(Image(systemName: AddPetViewImages.cameraIcon).foregroundColor(.white))
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        CustomTextField(label: RegistrationViewStrings.firstName, placeholder: "", text: $viewModel.firstName)
                        CustomTextField(label: RegistrationViewStrings.lastName, placeholder: "", text: $viewModel.lastName)
                        CustomTextField(label: ProfileViewString.phoneNumber, placeholder: ProfileViewString.placeholderPhone, text: $viewModel.phone)
                        CustomTextField(label: ProfileViewString.emailAddress, placeholder: "", text: $viewModel.email)
                        CustomTextField(label: RegistrationViewStrings.password, placeholder: "", text: $viewModel.password, isSecure: true)
                    }
                    
                    VStack(spacing: 12) {
                        PrimaryButton(title: ProfileViewString.saveChanges, isSecondary: false) {
                            //viewModel.saveChanges()
                            dismiss()
                        }
                        
                        Button(action: { viewModel.deleteAccount() }) {
                            Text(ProfileViewString.deleteAccount)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(hex: "#C9554D"))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
    }
}
