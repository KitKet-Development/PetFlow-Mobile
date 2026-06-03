//
//  VisitRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 29.05.2026.
//

import SwiftUI

struct VisitRow: View {
    let visit: VisitReadDTO
    let petId: Int
    let viewModel: PetDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(visit.title)
                        .font(.system(size: 15, weight: .semibold))
                    Text(visit.visit_date)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(visit.clinic.name)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#4A37A7"))
                }
                Spacer()

                // Кнопка скачать, если есть вложение
                if let attachments = visit.attachments, !attachments.isEmpty {
                    Button {
                        Task {
                            await viewModel.downloadAttachment(petId: petId, visit: visit)
                        }
                    } label: {
                        if viewModel.isDownloading {
                            ProgressView()
                                .frame(width: 32, height: 32)
                        } else {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color(hex: "#4A37A7"))
                        }
                    }
                    .disabled(viewModel.isDownloading)
                }
            }

            if let complaint = visit.complaint, !complaint.isEmpty {
                InfoRow(label: "Жалобы", value: complaint)
            }
            if let diagnosis = visit.diagnosis, !diagnosis.isEmpty {
                InfoRow(label: "Диагноз", value: diagnosis)
            }
            if let rec = visit.recommendation, !rec.isEmpty {
                InfoRow(label: "Рекомендации", value: rec)
            }

            if let downloadError = viewModel.downloadError {
                Text(downloadError)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(hex: "#F8F9FE"))
        .cornerRadius(12)
    }
}
