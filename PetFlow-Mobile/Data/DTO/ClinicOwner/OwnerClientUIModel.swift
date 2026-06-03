//
//  OwnerClientUIModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 01.06.2026.
//

import Foundation

struct OwnerClientUIModel: Identifiable {
    let id: Int
    let fullName: String
    let email: String
    let phone: String?
    let petsCount: Int
    let appointmentsCount: Int
    let avatarURL: String?
}
