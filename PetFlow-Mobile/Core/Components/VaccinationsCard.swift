//
//  VaccinationsCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct VaccinationsCard: View {
    let vaccinations: [VaccinationDTO]
    @State private var showAll = false

    private var displayed: [VaccinationDTO] {
        showAll ? vaccinations : Array(vaccinations.prefix(2))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Label("Вакцинации", systemImage: "ivfluid.bag.fill")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Text("Всего: \(vaccinations.count)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            if vaccinations.isEmpty {
                Text("Нет записей о вакцинациях")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(displayed.enumerated()), id: \.element.id) { index, vaccine in
                    VaccineRow(
                        title: vaccine.name,
                        date: vaccine.vaccinated_at,
                        expiresAt: vaccine.expires_at,
                        notes: vaccine.notes,
                        isDashed: index % 2 != 0
                    )
                }

                if vaccinations.count > 2 {
                    Button(showAll ? "Скрыть" : "Показать все вакцинации") {
                        withAnimation { showAll.toggle() }
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}
