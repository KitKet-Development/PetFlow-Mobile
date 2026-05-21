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
                    
                    // Блок дат — без изменений
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

                    // Блок слотов — реальные данные
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
                    
                    // Блок питомцев — без изменений
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
            await viewModel.loadData(clinicId: clinic.id) // один вызов вместо трёх
        }
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

struct BookingPetCardLocal: View {

    let pet: BookingPetUIModel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {
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
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color(hex: "#4A37A7") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: .black.opacity(0.04),
                radius: 6,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
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
