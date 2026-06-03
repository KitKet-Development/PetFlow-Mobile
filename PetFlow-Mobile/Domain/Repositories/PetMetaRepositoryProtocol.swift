//
//  PetMetaRepositoryProtocol.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

protocol PetMetaRepositoryProtocol {
    
    func getSpecies() async throws -> [SpeciesDTO]
    func getBreeds() async throws -> [BreedDTO]
}
