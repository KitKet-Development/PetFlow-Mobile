//
//  OwnerDashboardView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct OwnerDashboardView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @State private var showClinicInfo = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("PetFlow")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                AsyncImage(url: URL(string: "")) { _ in
                    Circle().fill(Color(hex: "#E8E3FF"))
                        .overlay(Image(systemName: "person.fill")
                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.5)))
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            if viewModel.isLoading {
                Spacer(); ProgressView(); Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        Button(action: { showClinicInfo = true }) {
                            clinicBanner
                        }
                        .buttonStyle(.plain)
                        
                        todaySection
                        
                        statsGrid
                        
                        quickActionsSection
                        
                        recentSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .sheet(isPresented: $showClinicInfo) {
            OwnerClinicInfoView(viewModel: viewModel)
        }
    }
    
    var clinicBanner: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: viewModel.clinic?.logo ?? "")) { phase in
                switch phase {
                case .success(let img): img.resizable().scaledToFill()
                default:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#E8E3FF"))
                        .overlay(Image(systemName: "building.2")
                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.4)))
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .allowsHitTesting(false)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.clinic?.name ?? "Моя клиника")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                if let address = viewModel.clinic?.address?.full_address {
                    Text(address)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color(hex: "#63B074")).frame(width: 6, height: 6)
                    Text("Открыто сейчас")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "#63B074"))
                }
            }
            
            Spacer()
            Image(systemName: "chevron.down")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    var todaySection: some View {
        HStack {
            Text("Сегодня")
                .font(.system(size: 17, weight: .bold))
            Spacer()
            Text(todayDisplayDate())
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
    }
    
    var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(
                title: "Записей сегодня",
                value: "\(viewModel.todayCount)",
                badge: nil,
                icon: "list.bullet.clipboard",
                color: "#4A37A7"
            )
            statCard(
                title: "Загруженность",
                value: "\(Int(viewModel.occupancy * 100))%",
                badge: occupancyLabel(),
                icon: "chart.bar.fill",
                color: "#63B074"
            )
            statCard(
                title: "Выручка за день",
                value: "— ₽",
                badge: nil,
                icon: "rublesign.circle",
                color: "#4A9BE3"
            )
            statCard(
                title: "Отмены",
                value: "\(viewModel.appointments.filter { $0.status == "canceled" }.count)",
                badge: nil,
                icon: "xmark.circle",
                color: "#C9554D"
            )
        }
    }
    
    func statCard(title: String, value: String, badge: String?,
                  icon: String, color: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: color))
                    .frame(width: 30, height: 30)
                    .background(Color(hex: color).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Spacer()
            }
            Text(value)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            if let badge {
                Text(badge)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#63B074"))
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
    }
    
    var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Быстрые действия")
                .font(.system(size: 15, weight: .semibold))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()),
                                GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                quickBtn(icon: "plus.circle.fill",    label: "Добавить\nзапись",     color: "#4A37A7") {}
                quickBtn(icon: "calendar.badge.plus", label: "Управление\nслотами",  color: "#63B074") {}
                quickBtn(icon: "person.badge.plus",   label: "Добавить\nврача",      color: "#F5A623") {}
                quickBtn(icon: "chart.bar",           label: "Статистика\nпо клинике", color: "#4A9BE3") {}
            }
        }
    }
    
    func quickBtn(icon: String, label: String, color: String,
                  action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: color))
                    .frame(width: 48, height: 48)
                    .background(Color(hex: color).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(.plain)
    }
    
    var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Последние записи")
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                Text("Смотреть все")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            
            if viewModel.appointments.isEmpty {
                emptyState(text: "Записей нет", icon: "calendar.badge.exclamationmark")
            } else {
                ForEach(viewModel.appointments.prefix(3)) { appt in
                    recentRow(appt)
                }
            }
            
            PrimaryButton(title: "Перейти в расписание", isSecondary: true) {}
        }
    }
    
    func recentRow(_ appt: AppointmentReadDTO) -> some View {
        let ui = viewModel.mapAppointment(appt)
        return HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: ui.statusColor).opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(Image(systemName: "pawprint.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: ui.statusColor)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(ui.petName).font(.system(size: 14, weight: .semibold))
                Text(appt.user.full_name.components(separatedBy: " ").prefix(2).joined(separator: " "))
                    .font(.system(size: 12)).foregroundColor(.secondary)
                Text(appt.clinic.name)
                    .font(.system(size: 11)).foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(ui.time)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Text(ui.status)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: ui.statusColor))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color(hex: ui.statusColor).opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
    }
    
    func todayDisplayDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMM, EEEE"
        return f.string(from: Date())
    }
    
    func occupancyLabel() -> String {
        let pct = Int(viewModel.occupancy * 100)
        if pct >= 80 { return "Высокая" }
        if pct >= 50 { return "Средняя" }
        return "Хорошая"
    }
}
