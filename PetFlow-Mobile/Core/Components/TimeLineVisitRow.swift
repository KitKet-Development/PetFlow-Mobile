//
//  TimeLineVisitRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import SwiftUI

struct TimelineVisitRow: View {
    let visit: VisitReadDTO
    let petId: Int
    let viewModel: PetDetailViewModel
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: "#4A37A7"))
                    .frame(width: 12, height: 12)
                    .padding(.top, 4)
                if !isLast {
                    Rectangle()
                        .fill(Color(hex: "#E0D9F7"))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                        .padding(.top, 4)
                }
            }
            .frame(width: 12)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(visit.visit_date.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#EDE8F5"))
                    .cornerRadius(20)
                
                Text(visit.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(visit.clinic.name)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#4A37A7"))
                
                if let complaint = visit.complaint, !complaint.isEmpty {
                    Text(complaint)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                if let diagnosis = visit.diagnosis, !diagnosis.isEmpty {
                    Text(diagnosis)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                if let rec = visit.recommendation, !rec.isEmpty {
                    Text(rec)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                if let attachments = visit.attachments, !attachments.isEmpty {
                    Button {
                        Task { await viewModel.downloadAttachment(petId: petId, visit: visit) }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "paperclip")
                                .font(.system(size: 12))
                            Text("Скачать файл")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.gray)
                    }
                    .disabled(viewModel.isDownloading)
                }
                
                if let err = viewModel.downloadError {
                    Text(err)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, isLast ? 0 : 20)
        }
    }
}
