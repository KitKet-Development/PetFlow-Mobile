//
//  DataExtension.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 19.05.2026.
//
import Foundation

extension Data {

    mutating func append(_ string: String) {

        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
