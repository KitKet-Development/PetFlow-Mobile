//
//  BookingView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct BookingView: View {
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
                            Text(BookingViewString.selectDateTitle).font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text("Март 2024").foregroundColor(Color(hex: "#4A37A7")).font(.system(size: 14))
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(viewModel.days, id: \.1) { day, date in
                                DateCard(day: day, date: date, isSelected: viewModel.selectedDate == date) {
                                    viewModel.selectedDate = date
                                }
                            }
                        }
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.timeSlots, id: \.self) { time in
                            TimeSlotCard(time: time, isSelected: viewModel.selectedTime == time) {
                                viewModel.selectedTime = time
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(BookingViewString.selectPetTitle).font(.system(size: 18, weight: .bold))
                        
                        ForEach(viewModel.pets) { pet in
                            PetSelectionRow(pet: pet, isSelected: viewModel.selectedPetId == pet.id) {
                                viewModel.selectedPetId = pet.id
                            }
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text(BookingViewString.addPetAction)
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "#4A37A7"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#4A37A7"), style: StrokeStyle(lineWidth: 1, dash: [5])))
                        }
                    }
                    
                    // 4. Комментарий
                    VStack(alignment: .leading, spacing: 12) {
                        Text(BookingViewString.commentTitle).font(.system(size: 18, weight: .bold))
                        Text("Что беспокоит вашего питомца?").font(.system(size: 13)).foregroundColor(.gray)
                        
                        TextEditor(text: $viewModel.comment)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0E0E0"), lineWidth: 1))
                    }
                    
                    VStack(spacing: 12) {
                        PrimaryButton(title: BookingViewString.confirmBooking, isSecondary: false) {
                            
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
    }
}

struct DateCard: View {
    let day: String
    let date: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(day).font(.system(size: 12))
                Text(date).font(.system(size: 18, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color(hex: "#4A37A7") : Color.white)
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
    }
}

struct TimeSlotCard: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(time)
                .font(.system(size: 14, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color(hex: "#4A37A7") : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
        }
    }
}

struct PetSelectionRow: View {
    let pet: PetMock
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(pet.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(pet.name).font(.system(size: 16, weight: .bold))
                    Text(pet.breed).font(.system(size: 13)).foregroundColor(.gray)
                    Text("3 года").font(.system(size: 12)).foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color(hex: "#4A37A7") : Color(hex: "#E0E0E0"))
                    .font(.system(size: 24))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color(hex: "#4A37A7") : Color.clear, lineWidth: 2))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BookingStepIndicator: View {
    let currentStep: Int
    var body: some View {
        HStack {
            StepCircle(number: "1", title: "ВРЕМЯ", isActive: currentStep >= 1)
            Line()
            StepCircle(number: "2", title: "ПИТОМЕЦ", isActive: currentStep >= 2)
            Line()
            StepCircle(number: "3", title: "ИНФО", isActive: currentStep >= 3)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func StepCircle(number: String, title: String, isActive: Bool) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isActive ? Color(hex: "#4A37A7") : Color(hex: "#E8EFFF"))
                    .frame(width: 30, height: 30)
                Text(number)
                    .foregroundColor(isActive ? .white : .gray)
                    .font(.system(size: 14, weight: .bold))
            }
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(isActive ? .black : .gray)
        }
    }
    
    @ViewBuilder
    func Line() -> some View {
        Rectangle()
            .fill(Color(hex: "#E8EFFF"))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
    }
}
