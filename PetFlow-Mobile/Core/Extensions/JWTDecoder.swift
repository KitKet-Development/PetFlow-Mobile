//
//  JWTDecoder.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 20.05.2026.
//

import Foundation

enum JWTDecoder {
    
    static func decodeUserID(from token: String) -> Int? {
        
        let segments = token.components(separatedBy: ".")
        
        guard segments.count > 1 else {
            return nil
        }
        
        var base64 = segments[1]
        
        base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let userIDString = json["user_id"] as? String,
              let userID = Int(userIDString) else {
            
            return nil
        }
        
        return userID
    }
}
