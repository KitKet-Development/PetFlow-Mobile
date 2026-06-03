//
//  OwnerEditClinicView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import SwiftUI

struct OwnerEditClinicView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name        = ""
    @State private var phone       = ""
    @State private var email       = ""
    @State private var website     = ""
    @State private var description = ""
    @State private var isSaving    = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    ZStack {
                        AsyncImage(url: URL(string: viewModel.clinic?.logo ?? "")) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default:
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "#E8E3FF"))
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.4))
                                    )
                            }
                        }
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .allowsHitTesting(false)
                    }
                    
                    VStack(spacing: 0) {
                        formField(label: "Название клиники", placeholder: "ВетПлюс", text: $name)
                        Divider().padding(.leading, 16)
                        formField(label: "Город", placeholder: viewModel.clinic?.address?.city ?? "Москва", text: .constant(""))
                        Divider().padding(.leading, 16)
                        formField(label: "Адрес", placeholder: viewModel.clinic?.address?.full_address ?? "", text: .constant(""))
                        Divider().padding(.leading, 16)
                        
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Телефон")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                TextField("+7 (999) 000-00-00", text: $phone)
                                    .font(.system(size: 14))
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            
                            Divider().frame(height: 50)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Электронная почта")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                TextField("info@clinic.ru", text: $email)
                                    .font(.system(size: 14))
                                    .keyboardType(.emailAddress)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity)
                        }
                        
                        Divider().padding(.leading, 16)
                        formField(label: "Сайт", placeholder: "https://clinic.ru", text: $website)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Описание")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                        TextEditor(text: $description)
                            .frame(height: 120)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                
                    HStack(spacing: 12) {
                        Button(action: { dismiss() }) {
                            Text("Отмена")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#4A37A7"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#4A37A7"), lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: saveChanges) {
                            Group {
                                if isSaving {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Сохранить изменения")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#4A37A7"))
                            .cornerRadius(14)
                        }
                        .buttonStyle(.plain)
                        .disabled(isSaving)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("Информация о клинике")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "#F8F9FE").ignoresSafeArea())
            .onAppear { prefill() }
        }
    }
    
    func formField(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            TextField(placeholder, text: text)
                .font(.system(size: 14))
        }
        .padding(16)
    }
    
    func prefill() {
        guard let c = viewModel.clinic else { return }
        name        = c.name
        phone       = c.phone ?? ""
        email       = c.email ?? ""
        description = c.description ?? ""
    }
    
    func saveChanges() {
        guard let c = viewModel.clinic else { return }
        isSaving = true
        Task {
            await viewModel.updateClinic(
                name: name, phone: phone.isEmpty ? nil : phone,
                email: email, description: description.isEmpty ? nil : description,
                addressId: c.address?.id ?? 0,
                species: c.species?.map { $0.id } ?? []
            )
            isSaving = false
            if viewModel.errorMessage == nil { dismiss() }
        }
    }
}
