//
//  OwnerPatientCardView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import SwiftUI
import Combine

import SwiftUI

struct OwnerPatientCardView: View {
    
    let appointment: AppointmentReadDTO
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTab = 0
    @State private var isEditing   = false
    @State private var isSaving    = false
    
    @State private var petName    = ""
    @State private var birthDate  = ""
    @State private var weight     = ""
    @State private var color      = ""
    @State private var microchip  = ""
    
    @State private var allergies  = ""
    @State private var medNotes   = ""
    
    let tabs = ["Медкарта", "История записей", "Документы"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                petHeader
                
                tabBar
                
                Group {
                    switch selectedTab {
                    case 0: medCardTab
                    case 1: historyTab
                    case 2: documentsTab
                    default: EmptyView()
                    }
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("Личная информация")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .task {
            await loadData()
        }
        .overlay {
            if isSaving {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView("Сохранение...")
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(14)
            }
        }
    }
    
    var petHeader: some View {
        HStack(spacing: 16) {
            Group {
                if let url = URL(string: viewModel.currentPet?.avatar ?? "") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        default:
                            petAvatarPlaceholder
                        }
                    }
                } else {
                    petAvatarPlaceholder
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.currentPet?.name ?? appointment.pet.name)
                    .font(.system(size: 20, weight: .bold))
                Text(viewModel.currentPet?.species.name ?? "—")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                if let breed = viewModel.currentPet?.breed?.name {
                    Text(breed)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
            }
            Spacer()
        }
        .padding(16)
        .background(Color.white)
    }
    
    var petAvatarPlaceholder: some View {
        Circle()
            .fill(Color(hex: "#E8E3FF"))
            .overlay(
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#4A37A7").opacity(0.4))
            )
    }
    
    var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                        if isEditing { isEditing = false }
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tab)
                            .font(.system(
                                size: 13,
                                weight: selectedTab == index ? .semibold : .regular
                            ))
                            .foregroundColor(
                                selectedTab == index
                                ? Color(hex: "#4A37A7")
                                : .secondary
                            )
                        Rectangle()
                            .fill(
                                selectedTab == index
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
        .padding(.horizontal, 16)
        .background(Color.white)
    }
    
    var medCardTab: some View {
        VStack(spacing: 16) {
            
            sectionCard(title: "Информация о питомце") {
                if isEditing {
                    editPetFields
                } else {
                    readPetFields
                }
            }
            
            sectionCard(title: "Информация о владельце") {
                VStack(spacing: 0) {
                    infoRow(label: "ФИО",        value: appointment.user.full_name)
                    Divider().padding(.leading, 16)
                    infoRow(label: "Телефон",    value: appointment.user.phone ?? "—")
                    Divider().padding(.leading, 16)
                    infoRow(label: "Эл. почта",  value: appointment.user.email)
                }
            }
            
            if isEditing {
                HStack(spacing: 12) {
                    Button(action: {
                        isEditing = false
                        prefillFields()
                    }) {
                        Text("Отмена")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#4A37A7"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#4A37A7"), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: savePetChanges) {
                        Text("Сохранить изменения")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#4A37A7"))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                    .disabled(isSaving)
                }
            } else {
                VStack(spacing: 12) {
                    Button(action: { isEditing = true }) {
                        Text("Редактировать")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#4A37A7"))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {}) {
                        Text("Удалить пациента")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#C9554D"))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    var readPetFields: some View {
        VStack(spacing: 0) {
            infoRow(
                label: "Кличка",
                value: viewModel.currentPet?.name ?? appointment.pet.name
            )
            Divider().padding(.leading, 16)
            infoRow(
                label: "Порода",
                value: viewModel.currentPet?.breed?.name ?? "—"
            )
            Divider().padding(.leading, 16)
            infoRow(
                label: "День рождения",
                value: formatDisplayDate(viewModel.currentPet?.birth_date)
            )
            Divider().padding(.leading, 16)
            infoRow(
                label: "Вес",
                value: viewModel.currentPet?.weight.map { "\($0) кг" } ?? "—"
            )
            Divider().padding(.leading, 16)
            infoRow(
                label: "Аллергии",
                value: viewModel.currentMedicalCard?.allergies ?? "—"
            )
            Divider().padding(.leading, 16)
            infoRow(
                label: "Заметки",
                value: viewModel.currentMedicalCard?.notes ?? "—"
            )
        }
    }
    
    var editPetFields: some View {
        VStack(spacing: 0) {
            editRow(label: "Кличка",        value: $petName,   placeholder: "Барсик")
            Divider().padding(.leading, 16)
            editRow(label: "День рождения", value: $birthDate, placeholder: "2023-01-15")
            Divider().padding(.leading, 16)
            editRow(label: "Вес (кг)",      value: $weight,    placeholder: "4.2")
            Divider().padding(.leading, 16)
            editRow(label: "Окрас",         value: $color,     placeholder: "Серый")
            Divider().padding(.leading, 16)
            editRow(label: "Микрочип",      value: $microchip, placeholder: "123456789")
            Divider().padding(.leading, 16)
            editRow(label: "Аллергии",      value: $allergies, placeholder: "Нет")
            Divider().padding(.leading, 16)
            editRow(label: "Заметки",       value: $medNotes,  placeholder: "Доп. информация")
        }
    }
    
    var historyTab: some View {
        VStack(spacing: 12) {
            let petAppts = viewModel.appointments
                .filter { $0.pet.id == appointment.pet.id }
                .sorted { "\($0.date) \($0.slot.start_time)" > "\($1.date) \($1.slot.start_time)" }
            
            if petAppts.isEmpty {
                emptyState(text: "История записей пуста", icon: "clock")
                    .padding(.top, 20)
            } else {
                ForEach(petAppts) { appt in
                    historyCard(appt)
                }
            }
            
            Button(action: {}) {
                Text("Создать новую запись")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#4A37A7"))
                    .cornerRadius(14)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    func historyCard(_ appt: AppointmentReadDTO) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(formatDisplayDate(appt.date) + ", " + appt.slot.start_time)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#4A37A7"))
                    if let comment = appt.comment, !comment.isEmpty {
                        Text(comment)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
                Spacer()
                Text(viewModel.mapStatus(appt.status))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: viewModel.statusColor(appt.status)))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: viewModel.statusColor(appt.status)).opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
    
    var documentsTab: some View {
        VStack(spacing: 12) {
            
            let visits = viewModel.currentMedicalCard?.visits ?? []
            
            if visits.isEmpty {
                emptyState(text: "Документов нет", icon: "doc.fill")
                    .padding(.top, 20)
            } else {
                ForEach(visits) { visit in
                    documentCard(visit)
                }
            }
            
            Button(action: {}) {
                Label("Загрузить новый документ", systemImage: "arrow.up.doc.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "#4A37A7"))
                    .cornerRadius(14)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    func documentCard(_ visit: VisitReadDTO) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(visit.title)
                        .font(.system(size: 14, weight: .semibold))
                    Text(formatDisplayDate(visit.visit_date))
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "doc.fill")
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            if let attachments = visit.attachments, !attachments.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(URL(string: attachments)?.lastPathComponent ?? attachments)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#4A37A7"))
                        .lineLimit(1)
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
    
    func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 4)
            content()
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    func editRow(
        label: String,
        value: Binding<String>,
        placeholder: String
    ) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            TextField(placeholder, text: value)
                .font(.system(size: 13))
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private func loadData() async {
        await viewModel.loadPet(petId: appointment.pet.id)
        prefillFields()
    }
    
    private func prefillFields() {
        guard let pet = viewModel.currentPet else { return }
        petName   = pet.name
        birthDate = pet.birth_date ?? ""
        weight    = pet.weight ?? ""
        color     = ""
        microchip = ""
        allergies = viewModel.currentMedicalCard?.allergies ?? ""
        medNotes  = viewModel.currentMedicalCard?.notes ?? ""
    }
    
    private func savePetChanges() {
        guard let pet = viewModel.currentPet else { return }
        isSaving = true
        
        Task {
            let petDTO = PetUpdateDTO(
                name:       petName.isEmpty ? pet.name : petName,
                species:    pet.species.id,
                breed:      pet.breed?.id,
                birth_date: birthDate.isEmpty ? nil : birthDate,
                weight:     weight.isEmpty    ? nil : weight,
                gender:     nil,
                color:      color.isEmpty     ? nil : color,
                microchip:  microchip.isEmpty  ? nil : microchip,
                allergies:  nil
            )
            await viewModel.updatePet(petId: pet.id, dto: petDTO)
            
            if let card = viewModel.currentMedicalCard {
                let medDTO = MedicalCardUpdateDTO(
                    id:           card.id,
                    notes:        medNotes.isEmpty  ? nil : medNotes,
                    allergies:    allergies.isEmpty ? nil : allergies,
                    conditions:   card.conditions,
                    vaccinations: card.vaccinations,
                    visits:       nil
                )
                await viewModel.updateMedicalCard(petId: pet.id, dto: medDTO)
            }
            
            await viewModel.loadPet(petId: pet.id)
            prefillFields()
            
            isSaving   = false
            isEditing  = false
        }
    }
    
    private static let apiFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat    = "yyyy-MM-dd"
        f.locale        = Locale(identifier: "en_US_POSIX")
        f.timeZone      = TimeZone(identifier: "UTC")
        return f
    }()
    
    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        f.locale     = Locale(identifier: "ru_RU")
        f.timeZone   = TimeZone(identifier: "UTC")
        return f
    }()
    
    private func formatDisplayDate(_ string: String?) -> String {
        guard let s = string,
              let date = Self.apiFormatter.date(from: s) else { return "—" }
        return Self.displayFormatter.string(from: date)
    }
}

