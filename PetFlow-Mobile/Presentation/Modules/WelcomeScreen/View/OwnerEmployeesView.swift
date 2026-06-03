//
//  OwnerEmployeesView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct OwnerEmployeesView: View {
 
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @State private var showAddVet = false
    @State private var newFirstName = ""
    @State private var newLastName = ""
    @State private var newSpecialization = ""
    @State private var newPhone = ""
    @State private var newEmail = ""
    @State private var newBio = ""
    @State private var searchText = ""
 
    var filtered: [VetProfileReadDTO] {
        guard !searchText.isEmpty else { return viewModel.vets }
        return viewModel.vets.filter {
            $0.full_name.lowercased().contains(searchText.lowercased()) ||
            ($0.specialization ?? "").lowercased().contains(searchText.lowercased())
        }
    }
 
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Сотрудники")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Button(action: { showAddVet = true }) {
                    Label("Добавить", systemImage: "plus")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
 
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Поиск по имени или специализации", text: $searchText)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
 
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    if filtered.isEmpty {
                        emptyState(text: "Сотрудников нет", icon: "stethoscope")
                            .padding(.top, 40)
                    } else {
                        ForEach(filtered) { vet in
                            vetCard(vet)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .sheet(isPresented: $showAddVet) {
            addVetSheet
        }
    }
 
    func vetCard(_ vet: VetProfileReadDTO) -> some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: vet.avatar ?? "")) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                default:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#E8E3FF"))
                        .overlay(Image(systemName: "person.fill")
                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.4)))
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(false)
 
            VStack(alignment: .leading, spacing: 3) {
                Text(vet.full_name)
                    .font(.system(size: 15, weight: .semibold))
                if let spec = vet.specialization {
                    Text("Специализация: \(spec)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                if let bio = vet.bio {
                    Text(bio)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
 
            Spacer()
 
            Button(action: { Task { await viewModel.deleteVet(vet.id) } }) {
                Image(systemName: "trash")
                    .font(.system(size: 15))
                    .foregroundColor(.red.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
 
    var addVetSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Новый сотрудник")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.top)
 
                    CustomTextField(label: "Имя *", placeholder: "Иван", text: $newFirstName)
                    CustomTextField(label: "Фамилия *", placeholder: "Иванов", text: $newLastName)
                    CustomTextField(label: "Специализация", placeholder: "Терапия, хирургия", text: $newSpecialization)
                    CustomTextField(label: "Телефон", placeholder: "+7 (999) 000-00-00", text: $newPhone)
                    CustomTextField(label: "Email", placeholder: "vet@clinic.ru", text: $newEmail)
                    CustomTextField(label: "О себе", placeholder: "Краткое описание...", text: $newBio)
 
                    PrimaryButton(title: "Добавить сотрудника", isSecondary: false) {
                        Task {
                            await viewModel.createVet(
                                firstName: newFirstName,
                                lastName: newLastName,
                                specialization: newSpecialization,
                                phone: newPhone.isEmpty ? nil : newPhone,
                                email: newEmail.isEmpty ? nil : newEmail,
                                bio: newBio.isEmpty ? nil : newBio
                            )
                            showAddVet = false
                        }
                    }
                    .disabled(newFirstName.isEmpty || newLastName.isEmpty)
                    .opacity(newFirstName.isEmpty || newLastName.isEmpty ? 0.5 : 1)
                }
                .padding(20)
            }
        }
    }
}

func ownerHeader(title: String) -> some View {
    HStack {
        Text(title)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color(hex: "#4A37A7"))
        Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
}
 
func emptyState(text: String, icon: String) -> some View {
    VStack(spacing: 12) {
        Image(systemName: icon)
            .font(.system(size: 36))
            .foregroundColor(Color(hex: "#4A37A7").opacity(0.3))
        Text(text)
            .font(.system(size: 14))
            .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
}
