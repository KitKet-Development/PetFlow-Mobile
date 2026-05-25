//
//  TokenResponseDTO.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

struct TokenResponseDTO: Codable {
    
    let access: String
    let refresh: String
}
