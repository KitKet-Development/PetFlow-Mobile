//
//  AddPetView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 10.05.2026.
//

import SwiftUI
import PhotosUI

struct AddPetView: View {
    @StateObject private var viewModel = AddPetViewModel()
    @StateObject private var storage = LocalStorageService.shared
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var petImage: Image? = nil
    @State private var petUIImage: UIImage? = nil
    @Environment(\.dismiss) var dismiss

    @State private var isRegistrationFinished = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: RegistrationViewImages.backIcon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Image(systemName: AddPetViewImages.profileIcon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#E0E0E0"))
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ZStack(alignment: .bottomTrailing) {
                        if let petImage = petImage {
                            petImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(20)
                                .clipped()
                        } else {
                            Image(AddPetViewImages.petPlaceholder)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#E8E3FF"))
                                .cornerRadius(20)
                                .clipped()
                        }

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Circle()
                                .fill(Color(hex: "#4A37A7"))
                                .frame(width: 44, height: 44)
                                .overlay(Image(systemName: AddPetViewImages.cameraIcon).foregroundColor(.white))
                        }
                        .padding(12)
                    }
                    .padding(.top, 20)
                    .task(id: selectedItem) {
                        await loadImage(from: selectedItem)
                    }

                    VStack(spacing: 8) {
                        Text(AddPetViewStrings.addPetTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.gray))
                        Text(AddPetViewStrings.addPetSubtitle)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 16) {
                        CustomTextField(
                            label: AddPetViewStrings.petNameLabel,
                            placeholder: AddPetViewStrings.petNamePlaceholder,
                            text: $viewModel.petName
                        )

                        DropdownField(
                            label: AddPetViewStrings.petTypeLabel,
                            placeholder: AddPetViewStrings.petTypePlaceholder,
                            selection: $viewModel.petType,
                            options: viewModel.petTypes
                        )
                    }

                    VStack(spacing: 16) {
                        PrimaryButton(
                            title: viewModel.isLoading
                            ? "Загрузка..."
                            : AddPetViewStrings.continueButton,
                            isSecondary: false
                        ) {

                            viewModel.onContinueTap(
                                image: petUIImage
                            )
                        }
                        .disabled(viewModel.isLoading)
                        .onChange(of: viewModel.success) { _, success in
                            if success {
                                isRegistrationFinished = true
                            }
                        }
                        Button(action: {
                            viewModel.onAddLaterTap()
                            isRegistrationFinished = true
                        }) {
                            Text(AddPetViewStrings.addLater)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "#4A37A7"))
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationDestination(isPresented: $isRegistrationFinished) {
            MainTabView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .alert(
            "Ошибка",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )
        ) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @MainActor
    private func loadImage(from pickerItem: PhotosPickerItem?) async {
        guard let data = try? await pickerItem?.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            return
        }
        petImage = Image(uiImage: uiImage)
        petUIImage = uiImage
    }
}
