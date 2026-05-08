//
//  WelcomeViewModel.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 08.05.2026.
//

import Foundation
import Combine

class WelcomeViewModel: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    
    
    func onRegistrationTap() {
        print("Переход к регистрации")
    }
    
    func onLoginTap() {
        print("Переход ко входу")
    }
}
