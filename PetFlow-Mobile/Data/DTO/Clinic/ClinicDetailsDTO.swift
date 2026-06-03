//
//  ClinicDetailsDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation
 
struct ReviewDTO: Codable, Identifiable {
    let id: Int
    let text: String
    let author: Int
    let score: Int
}
 
struct ReviewUIModel: Identifiable {
    let id: Int
    let authorName: String
    let text: String
    let score: Int
    let date: String
}
