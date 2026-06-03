//
//  BookingView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct BookingView: View {
    let clinic: ClinicDTO
    @StateObject private var viewModel = BookingViewModel()
    
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
            
            BookingStepIndicator(currentStep: 1)
                .padding(.vertical, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(BookingViewString.selectDateTitle)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text(clinic.name)
                                .foregroundColor(Color(hex: "#4A37A7"))
                                .font(.system(size: 14))
                        }
                        HStack(spacing: 12) {
                            ForEach(viewModel.days, id: \.1) { day, apiDate in
                                DateCard(
                                    day: day,
                                    date: String(apiDate.suffix(2)),
                                    isSelected: viewModel.selectedDate == apiDate
                                ) {
                                    viewModel.selectedDate = apiDate
                                }
                            }
                        }
                    }
                    
                    if viewModel.slots.isEmpty {
                        Text("Нет доступных слотов")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {
                            ForEach(viewModel.slots) { slot in
                                TimeSlotCard(
                                    time: slot.start_time,
                                    isSelected: viewModel.selectedSlotId == slot.id
                                ) {
                                    viewModel.selectedSlotId = slot.id
                                    viewModel.selectedTime = slot.start_time
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(BookingViewString.selectPetTitle)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            if let selectedPetId = viewModel.selectedPetId,
                               let selectedPet = viewModel.pets.first(where: { $0.id == selectedPetId }) {
                                Text(selectedPet.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "#4A37A7"))
                            }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 168)
                            
                        } else if viewModel.pets.isEmpty {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text(BookingViewString.addPetAction)
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "#4A37A7"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#4A37A7"), style: StrokeStyle(lineWidth: 1, dash: [5]))
                                )
                            }
                            
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.pets) { pet in
                                        BookingPetCardLocal(
                                            pet: pet,
                                            isSelected: viewModel.selectedPetId == pet.id
                                        ) {
                                            viewModel.selectedPetId = pet.id
                                        }
                                    }
                                }
                                .padding(.horizontal, 30)
                                .frame(height: 200)
                            }
                            .padding(.horizontal, -16)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(BookingViewString.commentTitle)
                            .font(.system(size: 18, weight: .bold))
                        Text("Что беспокоит вашего питомца?")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        TextEditor(text: $viewModel.comment)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0E0E0"), lineWidth: 1))
                    }
                    
                    VStack(spacing: 12) {
                        PrimaryButton(title: BookingViewString.confirmBooking, isSecondary: false) {
                            Task {
                                await viewModel.confirmBooking(clinicId: clinic.id)
                            }
                        }
                        
                        if let successMessage = viewModel.successMessage {
                            Text(successMessage)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.green)
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.red)
                        }
                        
                        Text(BookingViewString.bookingTerms)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .task {
            await viewModel.loadData(clinicId: clinic.id)
        }
    }
}
