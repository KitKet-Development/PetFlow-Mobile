//
//  ImageUploadService.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 18.05.2026.
//

import Foundation
import UIKit

final class ImageUploadService {

    static let shared = ImageUploadService()

    private init() {}

    func uploadPetPhoto(
        petId: Int,
        image: UIImage
    ) async throws {

        guard let url = URL(
            string: "\(APIConfig.shared.baseURL)/pets/\(petId)/"
        ) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        let boundary = UUID().uuidString

        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        if let token = TokenStorage.shared.accessToken {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        var data = Data()

        let imageData = image.jpegData(compressionQuality: 0.7) ?? Data()

        data.append("--\(boundary)\r\n".data(using: .utf8)!)

        data.append(
            "Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"
                .data(using: .utf8)!
        )

        data.append(
            "Content-Type: image/jpeg\r\n\r\n"
                .data(using: .utf8)!
        )

        data.append(imageData)

        data.append("\r\n".data(using: .utf8)!)

        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        _ = try await URLSession.shared.data(for: request)
    }
}
