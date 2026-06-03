//
//  ClinicDetailView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 27.05.2026.
//


import SwiftUI

struct ClinicDetailView: View {
    
    let clinic: ClinicDTO
    
    @StateObject private var viewModel: ClinicDetailViewModel
    @Environment(\.dismiss) var dismiss
    @State private var navigateToBooking = false
    
    init(clinic: ClinicDTO) {
        self.clinic = clinic
        _viewModel = StateObject(
            wrappedValue: ClinicDetailViewModel(clinic: clinic)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text(WelcomeViewStrings.welcomeTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Image(ProfileViewImages.userPhoto)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    aboutSection
                    tabSection
                    tabContentSection
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                }
            }
            
            bottomButton
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToBooking) {
            BookingView(clinic: clinic)
        }
        .task {
            switch viewModel.selectedTab {
            case .reviews:
                await viewModel.loadReviews(clinicId: clinic.id, reset: true)
            case .specialists:
                await viewModel.loadVets(clinicId: clinic.id)
            case .price:
                break
            }
        }
    }
}


private extension ClinicDetailView {
    
    var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            
            AsyncImage(url: URL(string: clinic.logo ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle()
                        .fill(Color(hex: "#E8E3FF"))
                        .overlay(
                            Image(systemName: "building.2")
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: "#4A37A7").opacity(0.3))
                        )
                }
            }
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .clipped()
            .allowsHitTesting(false)
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 260)
            .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(clinic.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                if let address = clinic.address?.full_address {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                        Text(address)
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 56)
            
            HStack(spacing: 12) {
                Button(action: { navigateToBooking = true }) {
                    Text("Записаться")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(hex: "#4A37A7"))
                        .cornerRadius(20)
                }
                .buttonStyle(.plain)
                
                Button(action: { viewModel.toggleFavorite() }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(viewModel.isFavorite ? .red : .white)
                        .frame(width: 38, height: 38)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                Label("О клинике", systemImage: "info.circle.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                
                if let description = clinic.description {
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(16)
            
            VStack(spacing: 0) {
                infoRow(
                    icon: "mappin.and.ellipse",
                    label: "АДРЕС",
                    value: clinic.address?.full_address ?? "—"
                )
                Divider().padding(.horizontal)
                infoRow(
                    icon: "clock",
                    label: "ЧАСЫ РАБОТЫ",
                    value: viewModel.workingHours
                )
            }
            .background(Color.white)
            .cornerRadius(16)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#4A37A7"))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    var tabSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(ClinicDetailTab.allCases, id: \.self) { tab in
                    Button(action: {
                        viewModel.selectedTab = tab
                        Task {
                            switch tab {
                            case .reviews:
                                if viewModel.reviews.isEmpty {
                                    await viewModel.loadReviews(clinicId: clinic.id, reset: true)
                                }
                            case .specialists:
                                if viewModel.specialists.isEmpty {
                                    await viewModel.loadVets(clinicId: clinic.id)
                                }
                            case .price:
                                break
                            }
                        }
                    }) {
                        VStack(spacing: 6) {
                            Text(tab.rawValue)
                                .font(.system(
                                    size: 14,
                                    weight: viewModel.selectedTab == tab ? .semibold : .regular
                                ))
                                .foregroundColor(
                                    viewModel.selectedTab == tab
                                    ? Color(hex: "#4A37A7")
                                    : .secondary
                                )
                            
                            Rectangle()
                                .fill(
                                    viewModel.selectedTab == tab
                                    ? Color(hex: "#4A37A7")
                                    : Color.clear
                                )
                                .frame(height: 2)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            
            Divider()
        }
        .padding(.top, 8)
        .background(Color(hex: "#F8F9FE"))
    }
    
    @ViewBuilder
    var tabContentSection: some View {
        switch viewModel.selectedTab {
        case .price:
            priceContent
        case .reviews:
            reviewsContent
        case .specialists:
            specialistsContent
        }
    }
    
    var priceContent: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.priceItems) { item in
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "#4A37A7").opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: item.iconName)
                            .font(.system(size: 18))
                            .foregroundColor(Color(hex: "#4A37A7"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 15, weight: .semibold))
                        Text(item.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(item.price)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
                .padding(14)
                .background(Color.white)
                .cornerRadius(14)
            }
        }
        .padding(.top, 16)
    }
    
    var reviewsContent: some View {
        VStack(spacing: 16) {
            
            HStack {
                Menu {
                    Button("Сначала новые") {}
                    Button("Сначала старые") {}
                    Button("По рейтингу") {}
                } label: {
                    HStack(spacing: 6) {
                        Text("Сначала новые")
                            .font(.system(size: 14))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.top, 12)
            
            if viewModel.isLoadingReviews && viewModel.reviews.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
            } else {
                ForEach(viewModel.reviews) { review in
                    reviewCard(review)
                }
                
                if viewModel.hasMoreReviews {
                    Button(action: {
                        Task {
                            await viewModel.loadReviews(clinicId: clinic.id)
                        }
                    }) {
                        Text("Показать ещё")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color(hex: "#4A37A7"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                }
                
                if viewModel.reviews.isEmpty && !viewModel.isLoadingReviews {
                    Text("Отзывов пока нет")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)
                }
            }
        }
    }
    
    func reviewCard(_ review: ReviewUIModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.authorName)
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                starsView(score: review.score)
                Text("\(review.score)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            if !review.date.isEmpty {
                Text(review.date)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Text(review.text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .lineSpacing(3)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
    
    func starsView(score: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= score ? "star.fill" : "star")
                    .font(.system(size: 11))
                    .foregroundColor(i <= score ? Color(hex: "#F5A623") : .secondary)
            }
        }
    }
    
    var specialistsContent: some View {
        VStack(spacing: 12) {
            
            if viewModel.isLoadingVets && viewModel.specialists.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                
            } else if viewModel.specialists.isEmpty && !viewModel.isLoadingVets {
                Text("Специалисты не найдены")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                
            } else {
                ForEach(viewModel.specialists) { specialist in
                    specialistCard(specialist)
                }
            }
        }
        .padding(.top, 16)
    }
    
    func specialistCard(_ specialist: SpecialistUIModel) -> some View {
        HStack(spacing: 14) {
            Group {
                if let url = specialist.imageURL.flatMap({ URL(string: $0) }) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            specialistPlaceholder
                        }
                    }
                } else {
                    specialistPlaceholder
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(specialist.name)
                    .font(.system(size: 15, weight: .semibold))
                
                Text("Специализация: \(specialist.specialization)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if let bio = specialist.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                if !specialist.experience.isEmpty {
                    Text("стаж \(specialist.experience)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
            }
            
            Spacer()
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
    
    var specialistPlaceholder: some View {
        Rectangle()
            .fill(Color(hex: "#E8E3FF"))
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#4A37A7").opacity(0.4))
            )
    }
    
    var bottomButton: some View {
        VStack(spacing: 0) {
            Divider()
            PrimaryButton(
                title: "Записаться на приём",
                isSecondary: false
            ) {
                navigateToBooking = true
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(hex: "#F8F9FE"))
    }
}
