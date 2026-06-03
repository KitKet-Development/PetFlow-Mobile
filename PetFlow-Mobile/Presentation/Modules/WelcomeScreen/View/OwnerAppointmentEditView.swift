//
//  OwnerApp.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import SwiftUI

import SwiftUI

struct OwnerAppointmentEditView: View {
    
    let appointment: AppointmentReadDTO
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: String
    @State private var selectedSlotId: Int
    @State private var comment: String
    @State private var selectedStatus: String
    
    @State private var isSaving = false
    
    init(
        appointment: AppointmentReadDTO,
        viewModel: OwnerDashboardViewModel
    ) {
        self.appointment = appointment
        self.viewModel = viewModel
        
        _selectedDate = State(
            initialValue: appointment.date
        )
        
        _selectedSlotId = State(
            initialValue: viewModel.slots.first {
                $0.start_time == appointment.slot.start_time &&
                $0.end_time == appointment.slot.end_time
            }?.id ?? 0
        )
        
        _comment = State(
            initialValue: appointment.comment ?? ""
        )
        
        _selectedStatus = State(
            initialValue: appointment.status ?? "pending"
        )
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 20) {
                
                appointmentSection
                
                patientSection
                
                ownerSection
                
                buttonsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(
            Color(hex: "#F8F9FE")
                .ignoresSafeArea()
        )
        .navigationTitle("Настройки записи")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension OwnerAppointmentEditView {
    
    var appointmentSection: some View {
        
        sectionCard(title: "О приёме") {
            
            VStack(spacing: 0) {
                
                infoRow(
                    label: "Врач",
                    value: "—"
                )
                
                Divider()
                    .padding(.leading, 16)
                
                infoRow(
                    label: "Клиника",
                    value: appointment.clinic.name
                )
                
                Divider()
                    .padding(.leading, 16)
                
                datePickerRow
                
                Divider()
                    .padding(.leading, 16)
                
                slotPickerRow
                
                Divider()
                    .padding(.leading, 16)
                
                statusPickerRow
            }
        }
    }
    
    var patientSection: some View {
        
        sectionCard(title: "Информация о пациенте") {
            
            VStack(spacing: 0) {
                
                infoRow(
                    label: "Пациент",
                    value: appointment.pet.name
                )
                
                Divider()
                    .padding(.leading, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Комментарий")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $comment)
                        .frame(height: 120)
                        .padding(8)
                        .background(
                            Color(hex: "#F8F9FE")
                        )
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    Color(hex: "#E0E0E0"),
                                    lineWidth: 1
                                )
                        )
                }
                .padding(16)
            }
        }
    }
    
    var ownerSection: some View {
        
        sectionCard(title: "Информация о владельце") {
            
            VStack(spacing: 0) {
                
                infoRow(
                    label: "Владелец",
                    value: appointment.user.full_name
                )
                
                Divider()
                    .padding(.leading, 16)
                
                infoRow(
                    label: "Телефон",
                    value: appointment.user.phone ?? "—"
                )
                
                Divider()
                    .padding(.leading, 16)
                
                infoRow(
                    label: "Email",
                    value: appointment.user.email
                )
            }
        }
    }
    
    var buttonsSection: some View {
        
        VStack(spacing: 12) {
            
            Button {
                saveChanges()
            } label: {
                
                Group {
                    
                    if isSaving {
                        
                        ProgressView()
                            .tint(.white)
                        
                    } else {
                        
                        Text("Сохранить изменения")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Color(hex: "#4A37A7")
                )
                .cornerRadius(14)
            }
            .disabled(isSaving)
            
            Button {
                
                Task {
                    
                    await viewModel.deleteAppointment(
                        appointment.id
                    )
                    
                    dismiss()
                }
                
            } label: {
                
                Text("Удалить запись")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Color(hex: "#C9554D")
                    )
                    .cornerRadius(14)
            }
        }
    }
}

private extension OwnerAppointmentEditView {
    
    var datePickerRow: some View {
        
        HStack {
            
            Text("Дата")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Menu {
                
                ForEach(nextDays(), id: \.self) { date in
                    
                    Button(displayDate(date)) {
                        selectedDate = apiDate(date)
                    }
                }
                
            } label: {
                
                HStack {
                    
                    Text(selectedDate)
                    
                    Image(systemName: "chevron.down")
                }
            }
        }
        .padding(16)
    }
    
    var slotPickerRow: some View {
        
        HStack {
            
            Text("Время")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Menu {
                
                ForEach(viewModel.slots) { slot in
                    
                    Button(
                        "\(slot.start_time) — \(slot.end_time)"
                    ) {
                        selectedSlotId = slot.id
                    }
                }
                
            } label: {
                
                HStack {
                    
                    Text(slotLabel())
                    
                    Image(systemName: "chevron.down")
                }
            }
        }
        .padding(16)
    }
    
    var statusPickerRow: some View {
        
        HStack {
            
            Text("Статус")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Menu {
                
                Button("Ожидает") {
                    selectedStatus = "pending"
                }
                
                Button("Подтверждено") {
                    selectedStatus = "confirmed"
                }
                
                Button("Завершено") {
                    selectedStatus = "completed"
                }
                
                Button("Отменено") {
                    selectedStatus = "canceled"
                }
                
            } label: {
                
                HStack {
                    
                    Text(
                        statusTitle(
                            selectedStatus
                        )
                    )
                    
                    Image(systemName: "chevron.down")
                }
            }
        }
        .padding(16)
    }
}

private extension OwnerAppointmentEditView {
    
    func saveChanges() {
        
        isSaving = true
        
        let dto = AppointmentPatchDTO(
            date: selectedDate,
            slot: selectedSlotId == 0 ? nil : selectedSlotId,
            comment: comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? nil
            : comment,
            status: selectedStatus
        )
        
        Task {
            
            await viewModel.updateAppointment(
                appointmentId: appointment.id,
                dto: dto
            )
            
            await MainActor.run {
                
                isSaving = false
                
                if viewModel.errorMessage == nil {
                    dismiss()
                }
            }
        }
    }
}

private extension OwnerAppointmentEditView {
    
    func statusTitle(
        _ status: String
    ) -> String {
        
        switch status {
            
        case "pending":
            return "Ожидает"
            
        case "confirmed":
            return "Подтверждено"
            
        case "completed":
            return "Завершено"
            
        case "canceled":
            return "Отменено"
            
        default:
            return status
        }
    }
    
    func slotLabel() -> String {
        
        guard let slot = viewModel.slots.first(
            where: { $0.id == selectedSlotId }
        ) else {
            
            return "\(appointment.slot.start_time) — \(appointment.slot.end_time)"
        }
        
        return "\(slot.start_time) — \(slot.end_time)"
    }
    
    func nextDays() -> [Date] {
        
        (0..<60).compactMap {
            
            Calendar.current.date(
                byAdding: .day,
                value: $0,
                to: Date()
            )
        }
    }
    
    func displayDate(
        _ date: Date
    ) -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(
            identifier: "ru_RU"
        )
        
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: date)
    }
    
    func apiDate(
        _ date: Date
    ) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(title)
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 8)
            
            content()
        }
        .background(.white)
        .cornerRadius(16)
    }
    
    func infoRow(
        label: String,
        value: String
    ) -> some View {
        
        HStack {
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14))
                .multilineTextAlignment(.trailing)
        }
        .padding(16)
    }
}
