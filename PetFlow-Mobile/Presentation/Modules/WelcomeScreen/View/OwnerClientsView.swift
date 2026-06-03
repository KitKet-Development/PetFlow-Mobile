//
//  OwnerClientsView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct OwnerClientsView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @State private var searchText = ""
    
    func fullName(for client: UserShortDTO) -> String {
        let first = client.first_name ?? ""
        let last = client.last_name ?? ""
        return "\(first) \(last)".trimmingCharacters(in: .whitespaces)
    }
    
    var filtered: [UserShortDTO] {
        viewModel.clients.filter { client in
            let name = fullName(for: client)
            guard !searchText.isEmpty else { return true }
            return name.lowercased().contains(searchText.lowercased()) ||
            client.email.lowercased().contains(searchText.lowercased()) ||
            (client.phone ?? "").contains(searchText)
        }
    }
    
    func appointmentsCount(for userId: Int) -> Int {
        viewModel.appointments.filter { $0.user.id == userId }.count
    }
    
    func pets(for userId: Int) -> [String] {
        let names = viewModel.appointments
            .filter { $0.user.id == userId }
            .map { $0.pet.name }
        return Array(Set(names)).sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Клиенты")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Text("\(filtered.count)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Поиск по имени, email или телефону", text: $searchText)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    if viewModel.appointments.isEmpty {
                        emptyState(text: "Ещё нет клиентов", icon: "person.slash")
                            .padding(.top, 40)
                    } else if filtered.isEmpty {
                        emptyState(text: "Клиент не найден", icon: "person.slash")
                            .padding(.top, 40)
                    } else {
                        ForEach(filtered) { client in
                            clientCard(client)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
    }
    
    func clientCard(_ client: UserShortDTO) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#E8E3FF"))
                Text(initials(for: client))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#4A37A7"))
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(fullName(for: client))
                    .font(.system(size: 15, weight: .semibold))
                Text(client.email)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                if let phone = client.phone {
                    Text(phone).font(.system(size: 12)).foregroundColor(.secondary)
                }
                
                let petNames = pets(for: client.id)
                if !petNames.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.6))
                        Text(petNames.joined(separator: ", "))
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#4A37A7"))
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                let count = appointmentsCount(for: client.id)
                Text("\(count)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Text("записей")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(14)
    }
    
    func initials(for client: UserShortDTO) -> String {
        let first = (client.first_name?.first.map { String($0) } ?? "")
        let second = (client.last_name?.first.map { String($0) } ?? "")
        return "\(first)\(second)".uppercased()
    }
}

