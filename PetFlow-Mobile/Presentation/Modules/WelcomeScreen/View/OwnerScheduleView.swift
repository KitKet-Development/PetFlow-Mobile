//
//  OwnerScheduleView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct OwnerScheduleView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    
    @State private var selectedAppointment: AppointmentReadDTO?
    @State private var selectedVetFilter: Int?
    
    @State private var weekOffset = 0
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        return cal
    }()
    
    var filteredAppointments: [AppointmentReadDTO] {
        
        var appointments = viewModel.appointmentsForSelectedDate
        
        if let vetId = selectedVetFilter {
            
            _ = vetId
        }
        
        return appointments.sorted {
            $0.slot.start_time < $1.slot.start_time
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            header
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 16) {
                    
                    HStack {
                        
                        Text("Расписание")
                            .font(.system(size: 22, weight: .bold))
                        
                        Spacer()
                        
                        Text(monthYear())
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#4A37A7"))
                    }
                    .padding(.horizontal, 20)
                    
                    weekStrip
                    
                    vetFilter
                    
                    timelineView
                    
                    Button {
                        
                    } label: {
                        
                        Text("Создать новую запись")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#4A37A7"))
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(
            Color(hex: "#F8F9FE")
                .ignoresSafeArea()
        )
        .navigationDestination(item: $selectedAppointment) { appointment in
            
            OwnerAppointmentEditView(
                appointment: appointment,
                viewModel: viewModel
            )
        }
    }
}

extension OwnerScheduleView {
    
    var header: some View {
        
        HStack {
            
            Button(action: {}) {
                
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            
            Text("PetFlow")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#4A37A7"))
            
            Spacer()
            
            Circle()
                .fill(Color(hex: "#E8E3FF"))
                .frame(width: 36, height: 36)
                .overlay {
                    
                    Image(systemName: "person.fill")
                        .foregroundColor(
                            Color(hex: "#4A37A7")
                                .opacity(0.5)
                        )
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

extension OwnerScheduleView {
    
    var weekStrip: some View {
        
        HStack(spacing: 0) {
            
            Button {
                
                shiftWeek(-1)
                
            } label: {
                
                Image(systemName: "chevron.left")
                    .foregroundColor(.secondary)
                    .frame(width: 32)
            }
            
            HStack(spacing: 6) {
                
                ForEach(weekDays(), id: \.self) { date in
                    
                    Button {
                        
                        withAnimation {
                            
                            viewModel.selectedDate = date
                        }
                        
                    } label: {
                        
                        VStack(spacing: 4) {
                            
                            Text(dayNumber(date))
                                .font(.system(size: 17, weight: .bold))
                            
                            Text(dayShort(date))
                                .font(.system(size: 11))
                        }
                        .frame(width: 48, height: 60)
                        .background(
                            isSelected(date)
                            ? Color(hex: "#4A37A7")
                            : Color.white
                        )
                        .foregroundColor(
                            isSelected(date)
                            ? .white
                            : .primary
                        )
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Button {
                
                shiftWeek(1)
                
            } label: {
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .frame(width: 32)
            }
        }
        .padding(.horizontal, 12)
    }
    
    func startOfWeek() -> Date {
        
        let current = calendar.date(
            byAdding: .weekOfYear,
            value: weekOffset,
            to: viewModel.selectedDate
        ) ?? Date()
        
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: current
        )
        
        return calendar.date(from: components) ?? current
    }
    
    func weekDays() -> [Date] {
        
        let monday = startOfWeek()
        
        return (0..<7).compactMap {
            
            calendar.date(
                byAdding: .day,
                value: $0,
                to: monday
            )
        }
    }
    
    func shiftWeek(_ value: Int) {
        
        weekOffset += value
        
        viewModel.selectedDate =
        calendar.date(
            byAdding: .weekOfYear,
            value: value,
            to: viewModel.selectedDate
        ) ?? Date()
    }
    
    func dayNumber(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }
    
    func dayShort(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EE"
        
        return String(
            formatter.string(from: date)
                .prefix(2)
                .uppercased()
        )
    }
    
    func isSelected(_ date: Date) -> Bool {
        
        calendar.isDate(
            date,
            inSameDayAs: viewModel.selectedDate
        )
    }
}

extension OwnerScheduleView {
    
    var vetFilter: some View {
        
        HStack {
            
            Menu {
                
                Button("Все врачи") {
                    
                    selectedVetFilter = nil
                }
                
                ForEach(viewModel.vets) { vet in
                    
                    Button(vet.full_name) {
                        
                        selectedVetFilter = vet.id
                    }
                }
                
            } label: {
                
                HStack {
                    
                    Text(
                        selectedVetFilter == nil
                        ? "Все врачи"
                        : (
                            viewModel.vets.first {
                                $0.id == selectedVetFilter
                            }?.full_name ?? ""
                        )
                    )
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
    }
}

extension OwnerScheduleView {
    
    var timelineView: some View {
        
        VStack(spacing: 0) {
            
            ForEach(timeSlots(), id: \.self) { hour in
                
                let appointments = filteredAppointments.filter {
                    
                    $0.slot.start_time.hasPrefix(
                        String(format: "%02d", hour)
                    )
                }
                
                HStack(alignment: .top, spacing: 8) {
                    
                    Text(
                        String(format: "%02d:00", hour)
                    )
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(width: 44, alignment: .trailing)
                    .padding(.top, 8)
                    
                    VStack(spacing: 6) {
                        
                        if appointments.isEmpty {
                            
                            Divider()
                                .padding(.top, 16)
                            
                        } else {
                            
                            ForEach(appointments) { appointment in
                                
                                scheduleCard(appointment)
                                    .onTapGesture {
                                        
                                        selectedAppointment = appointment
                                    }
                            }
                        }
                    }
                    
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 4)
                .frame(minHeight: appointments.isEmpty ? 40 : nil)
            }
        }
        .padding(.horizontal, 16)
    }
    
    func timeSlots() -> [Int] {
        
        let hours = filteredAppointments.compactMap {
            
            Int($0.slot.start_time.prefix(2))
        }
        
        let minHour = max((hours.min() ?? 8) - 1, 0)
        let maxHour = min((hours.max() ?? 20) + 1, 23)
        
        return Array(minHour...maxHour)
    }
}

extension OwnerScheduleView {
    
    func scheduleCard(_ appointment: AppointmentReadDTO) -> some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(appointment.pet.name)
                    .font(.system(size: 13, weight: .semibold))
                
                Text(
                    "\(appointment.slot.start_time) - \(appointment.slot.end_time)"
                )
                .font(.system(size: 11))
                .foregroundColor(.gray)
                
                Text(appointment.user.full_name)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
}

extension OwnerScheduleView {
    
    func monthYear() -> String {
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        
        return formatter.string(
            from: viewModel.selectedDate
        ).capitalized
    }
}
