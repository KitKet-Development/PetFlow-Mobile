//
//  UserAppointmentsView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

import SwiftUI

struct UserAppointmentsView: View {
    @StateObject private var viewModel = BookingViewModel()

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Мои записи")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            } else if viewModel.appointments.isEmpty {
                Spacer()
                Text("У вас пока нет записей")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.appointments) { appointment in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(appointment.title)
                                    .font(.system(size: 16, weight: .semibold))

                                Text(appointment.subtitle)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)

                                Text(appointment.status)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#4A37A7"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color(hex: "#F8F9FE").ignoresSafeArea())
        .task {
            await viewModel.loadAppointments()
        }
    }
}
