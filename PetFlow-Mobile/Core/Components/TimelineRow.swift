//
//  TimelineRow.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 17.05.2026.
//

import SwiftUI

struct TimelineRow: View {
    let record: HealthRecord
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: "#4A37A7"))
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color(hex: "#E0E0E0"))
                    .frame(width: 2)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(record.date)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#E8E3FF"))
                    .foregroundColor(Color(hex: "#4A37A7"))
                    .cornerRadius(8)
                
                Text(record.title).font(.system(size: 16, weight: .bold))
                
                if let doc = record.doctor {
                    Text("Терапевт: \(doc)").font(.system(size: 13)).foregroundColor(.gray)
                }
                
                Text(record.description).font(.system(size: 13)).foregroundColor(.gray)
                
                if let file = record.fileName {
                    HStack {
                        Image(systemName: PetDetailViewImages.paperclipIcon)
                        Text(file)
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 20)
        }
    }
}
