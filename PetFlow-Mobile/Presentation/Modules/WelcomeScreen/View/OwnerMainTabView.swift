//
//  OwnerMainTabView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI
 
struct OwnerMainTabView: View {
 
    @State private var selectedTab: OwnerTab = .dashboard
    @StateObject private var viewModel = OwnerDashboardViewModel()
 
    enum OwnerTab {
        case dashboard, schedule, bookings, clients, employees
    }
 
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .dashboard:
                    OwnerDashboardView(viewModel: viewModel)
                case .schedule:
                    OwnerScheduleView(viewModel: viewModel)
                case .bookings:
                    OwnerBookingsView(viewModel: viewModel)
                case .clients:
                    OwnerClientsView(viewModel: viewModel)
                case .employees:
                    OwnerEmployeesView(viewModel: viewModel)
                }
            }
 
            HStack {
                OwnerTabItem(title: "Cabinet", icon: "building.2", isSelected: selectedTab == .dashboard) {
                    selectedTab = .dashboard
                }
                OwnerTabItem(title: "Schedule", icon: "calendar", isSelected: selectedTab == .schedule) {
                    selectedTab = .schedule
                }
                OwnerTabItem(title: "Bookings", icon: "book", isSelected: selectedTab == .bookings) {
                    selectedTab = .bookings
                }
                OwnerTabItem(title: "Clients", icon: "person.2", isSelected: selectedTab == .clients) {
                    selectedTab = .clients
                }
                OwnerTabItem(title: "Employees", icon: "stethoscope", isSelected: selectedTab == .employees) {
                    selectedTab = .employees
                }
            }
            .frame(height: 70)
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
        }
        .task {
            await viewModel.loadAll()
        }
    }
}
 
struct OwnerTabItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
 
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isSelected ? Color(hex: "#4A37A7") : Color.clear)
            .cornerRadius(12)
        }
    }
}
 
