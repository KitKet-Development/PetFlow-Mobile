//
//  PetRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 16.05.2026.
//

import Foundation

protocol PetRepositoryProtocol {
    
    func getPets() async throws -> [PetDTO]
    
    func createPet(request: CreatePetRequestDTO) async throws
}
