//
//  PaginationResponse.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//

struct PaginatedResponse<T: Codable>: Codable {

    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
}
