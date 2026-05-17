//
//  AddPetViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 10.05.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AddPetViewModel: ObservableObject {

    @Published var petName = ""
    @Published var petType = ""

    @Published var petImage: UIImage?

    let petTypes = [
        "Собака",
        "Кот",
        "Попугай",
        "Грызун",
        "Другое"
    ]

    private let session = AppSession.shared

    func onContinueTap() async {

        let pet = LocalPet(
            name: petName,
            type: petType,
            image: petImage
        )

        session.pets.append(pet)
    }

    func onAddLaterTap() {
        print("Skip pet")
    }
}
