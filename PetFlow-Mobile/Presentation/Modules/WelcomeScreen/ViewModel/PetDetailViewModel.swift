//
//  PetDetailViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import Foundation
import Combine

@MainActor
final class PetDetailViewModel: ObservableObject {

    @Published var medicalCard: MedicalCardDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var downloadedFileURL: URL?
    @Published var isDownloading = false
    @Published var downloadError: String?

    private let getMedicalCardUseCase: GetMedicalCardUseCase
    private let downloadAttachmentUseCase: DownloadVisitAttachmentUseCase

    init(
        getMedicalCardUseCase: GetMedicalCardUseCase? = nil,
        downloadAttachmentUseCase: DownloadVisitAttachmentUseCase? = nil
    ) {
        self.getMedicalCardUseCase = getMedicalCardUseCase
            ?? DependencyContainer.shared.getMedicalCardUseCase
        self.downloadAttachmentUseCase = downloadAttachmentUseCase
            ?? DependencyContainer.shared.downloadVisitAttachmentUseCase
    }

    func loadMedicalCard(petId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            medicalCard = try await getMedicalCardUseCase.execute(petId: petId)
        } catch {
            errorMessage = "Не удалось загрузить медкарту"
            print("❌ loadMedicalCard: \(error)")
        }
        isLoading = false
    }

    func downloadAttachment(petId: Int, visit: VisitReadDTO) async {
        isDownloading = true
        downloadError = nil
        do {
            guard let attachmentURLString = visit.attachments,
                  !attachmentURLString.isEmpty else {
                downloadError = "Файл отсутствует"
                isDownloading = false
                return
            }
            let data = try await downloadAttachmentUseCase.execute(
                petId: petId,
                visitId: visit.id
            )
            let fileName = "visit_\(visit.id).pdf"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try data.write(to: tempURL)
            downloadedFileURL = tempURL
        } catch {
            downloadError = "Ошибка загрузки файла"
            print("❌ downloadAttachment: \(error)")
        }
        isDownloading = false
    }
    
    func conditionStatusLabel(_ status: String?) -> String {
        switch status {
        case "active":     return "Активное"
        case "controlled": return "Контролируемое"
        case "remission":  return "Ремиссия"
        default:           return "Неизвестно"
        }
    }

    func conditionStatusColor(_ status: String?) -> (bg: String, text: String) {
        switch status {
        case "active":     return ("#FFEBEC", "#C9554D")
        case "controlled": return ("#FFF8E1", "#B07D00")
        case "remission":  return ("#E8F5E9", "#2E7D32")
        default:           return ("#F0F4FF", "#4A37A7")
        }
    }
}
