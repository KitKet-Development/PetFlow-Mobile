//
//  ClinicCatalogView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 12.05.2026.
//

import SwiftUI

struct ClinicCatalogView: View {

    @State private var selectedBookingClinic: ClinicDTO?
    @StateObject private var viewModel = ClinicCatalogViewModel()

    var body: some View {

        VStack(spacing: 16) {
            headerView
            searchView
            filtersView
            contentView
        }
        .background(Color(hex: "#F8F9FE"))
        .task {
            await viewModel.fetchClinics()
        }
    }
}

private extension ClinicCatalogView {
    
    var headerView: some View {

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
    }

    var searchView: some View {
        HStack {
            Image(systemName: ClinicCatalogViewImages.searchIcon)
                .foregroundColor(.gray)
            TextField(
                ClinicCatalogViewString.searchPlaceholder,
                text: $viewModel.searchText // ← биндинг на viewModel
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E0E0E0")))
        .padding(.horizontal)
    }

    var filtersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.filterTitles, id: \.self) { title in
                    FilterChip(
                        title: title,
                        icon: title == "Все" ? ClinicCatalogViewImages.filterIcon : nil,
                        isSelected: viewModel.selectedFilter == title
                    )
                    .onTapGesture {
                        viewModel.selectFilter(title) // ← серверный запрос
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            Spacer()
            ProgressView()
            Spacer()
        } else if let errorMessage = viewModel.errorMessage {
            Spacer()
            Text(errorMessage).foregroundColor(.red)
            Spacer()
        } else {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.clinics) { clinic in
                        ClinicCard(clinic: clinic) {
                            selectedBookingClinic = clinic
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationDestination(item: $selectedBookingClinic) { clinic in
                BookingView(clinic: clinic)
            }
        }
    }
}
