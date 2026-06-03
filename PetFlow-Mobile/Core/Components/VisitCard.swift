//
//  VisitCard.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct VisitsCard: View {
    let visits: [VisitReadDTO]
    let petId: Int
    let viewModel: PetDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Label("История здоровья", systemImage: "clock.arrow.circlepath")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#4A37A7"))
            }

            if visits.isEmpty {
                Text("История посещений пуста")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(visits.enumerated()), id: \.element.id) { index, visit in
                        TimelineVisitRow(
                            visit: visit,
                            petId: petId,
                            viewModel: viewModel,
                            isLast: index == visits.count - 1
                        )
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}
