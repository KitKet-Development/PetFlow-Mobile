//
//  SlotDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 21.05.2026.
//

struct SlotDTO: Codable, Identifiable {
    let id: Int
    let clinic: Int
    let start_time: String
    let end_time: String
}
