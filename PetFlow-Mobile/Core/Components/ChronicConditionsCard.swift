//
//  ChronicConditionsCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct ChronicConditionsCard: View {
    let conditions: [ChronicConditionDTO]
    let allergies: String?
    let notes: String?
    let viewModel: PetDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Label("Хронические заболевания", systemImage: "cross.case.fill")
                .font(.system(size: 17, weight: .bold))

            if conditions.isEmpty {
                Text("Хронических заболеваний не выявлено")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(conditions) { condition in
                        let colors = viewModel.conditionStatusColor(condition.status)
                        DiseaseChip(
                            title: condition.name,
                            color: Color(hex: colors.bg),
                            textColor: Color(hex: colors.text),
                            icon: "exclamationmark.circle"
                        )
                    }
                }

                ForEach(conditions) { condition in
                    if let desc = condition.description, !desc.isEmpty {
                        Text(desc)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }
            }

            if let allergies, !allergies.isEmpty {
                Divider()
                noteRow(label: "Аллергии", value: allergies)
            }

            if let notes, !notes.isEmpty {
                Divider()
                noteRow(label: "Заметки врача", value: notes)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }

    private func noteRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#4A37A7"))
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }
}
