//
//  OwnerBookingView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct OwnerBookingsView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @State private var searchText = ""
    @State private var selectedAppointment: AppointmentReadDTO?
    
    enum BookingDateFilter: String, CaseIterable {
        case all      = "Все даты"
        case today    = "Сегодня"
        case tomorrow = "Завтра"
        case week     = "Неделя"
        case month    = "Месяц"
    }
    
    @State private var dateFilter: BookingDateFilter = .all
    @State private var selectedVetId: Int?    = nil
    @State private var selectedStatus: String? = nil
    
    private static let apiFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()
    
    var filtered: [AppointmentReadDTO] {
        viewModel.appointments
            .filter { appt in
                let searchMatch =
                searchText.isEmpty
                || appt.pet.name.localizedCaseInsensitiveContains(searchText)
                || appt.user.full_name.localizedCaseInsensitiveContains(searchText)
                
                let statusMatch =
                selectedStatus == nil
                || appt.status == selectedStatus
                
                let dateMatch = matchesDateFilter(appt)
                
                return searchMatch && statusMatch && dateMatch
            }
            .sorted {
                if $0.date == $1.date {
                    return $0.slot.start_time < $1.slot.start_time
                }
                return $0.date < $1.date
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Записи")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button(action: {}) {
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
                TextField("Поиск по питомцу или владельцу", text: $searchText)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Menu {
                        ForEach(BookingDateFilter.allCases, id: \.self) { filter in
                            Button(action: { dateFilter = filter }) {
                                if dateFilter == filter {
                                    Label(filter.rawValue, systemImage: "checkmark")
                                } else {
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    } label: {
                        filterChip(
                            title: dateFilter == .all ? "Все даты" : dateFilter.rawValue,
                            systemImage: "calendar",
                            isSelected: dateFilter != .all
                        )
                    }
                    Menu {
                        Button(action: { selectedVetId = nil }) {
                            if selectedVetId == nil {
                                Label("Все врачи", systemImage: "checkmark")
                            } else {
                                Text("Все врачи")
                            }
                        }
                        Divider()
                        ForEach(viewModel.vets) { vet in
                            Button(action: { selectedVetId = vet.id }) {
                                if selectedVetId == vet.id {
                                    Label(vet.full_name, systemImage: "checkmark")
                                } else {
                                    Text(vet.full_name)
                                }
                            }
                        }
                    } label: {
                        filterChip(
                            title: selectedVetId == nil
                            ? "Все врачи"
                            : (viewModel.vets.first { $0.id == selectedVetId }?.full_name ?? "Врач"),
                            systemImage: "stethoscope",
                            isSelected: selectedVetId != nil
                        )
                    }
                    Menu {
                        Button(action: { selectedStatus = nil }) {
                            if selectedStatus == nil {
                                Label("Все статусы", systemImage: "checkmark")
                            } else {
                                Text("Все статусы")
                            }
                        }
                        Divider()
                        ForEach([
                            ("pending",   "Ожидает"),
                            ("confirmed", "Подтверждено"),
                            ("completed", "Завершено"),
                            ("canceled",  "Отменено"),
                        ], id: \.0) { raw, label in
                            Button(action: { selectedStatus = raw }) {
                                if selectedStatus == raw {
                                    Label(label, systemImage: "checkmark")
                                } else {
                                    Text(label)
                                }
                            }
                        }
                    } label: {
                        filterChip(
                            title: selectedStatus == nil
                            ? "Все статусы"
                            : viewModel.mapStatus(selectedStatus),
                            systemImage: "line.3.horizontal.decrease.circle",
                            isSelected: selectedStatus != nil
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 8)
            if !searchText.isEmpty || dateFilter != .all || selectedVetId != nil || selectedStatus != nil {
                HStack {
                    Text("Найдено: \(filtered.count)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: resetFilters) {
                        Text("Сбросить")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#4A37A7"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 6)
            }
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 40)
                    } else if filtered.isEmpty {
                        emptyState(
                            text: viewModel.appointments.isEmpty
                            ? "Записей нет"
                            : "Ничего не найдено",
                            icon: "calendar.badge.exclamationmark"
                        )
                        .padding(.top, 40)
                    } else {
                        ForEach(filtered) { appt in
                            bookingRow(appt)
                                .contentShape(Rectangle())
                                .onTapGesture { selectedAppointment = appt }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .navigationDestination(item: $selectedAppointment) { appt in
            OwnerPatientCardView(appointment: appt, viewModel: viewModel)
        }
    }
    
    func filterChip(title: String, systemImage: String, isSelected: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 11))
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)
            Image(systemName: "chevron.down")
                .font(.system(size: 9, weight: .semibold))
        }
        .foregroundColor(isSelected ? .white : .primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(isSelected ? Color(hex: "#4A37A7") : Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 4, y: 1)
    }
    
    func bookingRow(_ appt: AppointmentReadDTO) -> some View {
        let ui = viewModel.mapAppointment(appt)
        return HStack(spacing: 12) {
            
            Circle()
                .fill(Color(hex: "#E8E3FF"))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#4A37A7").opacity(0.5))
                )
            
            VStack(alignment: .leading, spacing: 3) {
                Text(ui.petName)
                    .font(.system(size: 14, weight: .semibold))
                Text(appt.user.full_name)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    Text(ui.date)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(ui.time)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Text(ui.status)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: ui.statusColor))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: ui.statusColor).opacity(0.12))
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.03), radius: 4, y: 1)
    }
    
    private func matchesDateFilter(_ appt: AppointmentReadDTO) -> Bool {
        guard dateFilter != .all else { return true }
        
        guard let date = Self.apiFormatter.date(from: appt.date) else {
            return false
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        switch dateFilter {
        case .all:
            return true
        case .today:
            return calendar.isDateInToday(date)
        case .tomorrow:
            return calendar.isDateInTomorrow(date)
        case .week:
            let now = Date()
            guard
                let weekStart = calendar.date(
                    from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
                ),
                let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)
            else { return false }
            return date >= weekStart && date < weekEnd
        case .month:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
    }
    
    private func resetFilters() {
        searchText     = ""
        dateFilter     = .all
        selectedVetId  = nil
        selectedStatus = nil
    }
}
