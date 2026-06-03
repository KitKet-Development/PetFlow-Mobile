//
//  OwnerClinicInfoView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 03.06.2026.
//

import SwiftUI

struct OwnerClinicInfoView: View {
    
    @ObservedObject var viewModel: OwnerDashboardViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showEdit = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: viewModel.clinic?.logo ?? "")) { phase in
                                switch phase {
                                case .success(let img): img.resizable().scaledToFill()
                                default:
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "#E8E3FF"))
                                        .overlay(Image(systemName: "building.2")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color(hex: "#4A37A7").opacity(0.4)))
                                }
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .allowsHitTesting(false)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(viewModel.clinic?.name ?? "—")
                                    .font(.system(size: 17, weight: .bold))
                                if let phone = viewModel.clinic?.phone {
                                    Text(phone)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                if let email = viewModel.clinic?.email {
                                    Text(email)
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(hex: "#4A37A7"))
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    if let desc = viewModel.clinic?.description, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("О клинике")
                                .font(.system(size: 15, weight: .semibold))
                            Text(desc)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Адрес")
                            .font(.system(size: 15, weight: .semibold))
                        if let addr = viewModel.clinic?.address {
                            Text(addr.full_address)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(16)
                    
                    Button(action: { showEdit = true }) {
                        Text("Редактировать")
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
            .navigationTitle("Информация о клинике")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                        Text("PetFlow")
                    }
                    .foregroundColor(Color(hex: "#4A37A7"))
                }
            }
            .background(Color(hex: "#F8F9FE").ignoresSafeArea())
            .sheet(isPresented: $showEdit, onDismiss: {
            }) {
                OwnerEditClinicView(viewModel: viewModel)
            }
        }
    }
}
