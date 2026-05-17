//
//  NotificationsSettingsView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var push = true
    @State private var email = false
    @State private var sms = false
    @State private var calls = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) { Image(systemName: "chevron.left").foregroundColor(Color(hex: "4A37A7")) }
                Spacer()
                Text("Настройка уведомлений").font(.system(size: 18, weight: .semibold))
                Spacer()
                Color.clear.frame(width: 20)
            }.padding()
            
            VStack(spacing: 20) {
                Toggle("Push уведомления", isOn: $push)
                Toggle("Получать электронные письма", isOn: $email)
                Toggle("Получать СМС", isOn: $sms)
                Toggle("Телефонные звонки", isOn: $calls)
                
                PrimaryButton(title: "Сохранить изменения", isSecondary: false) { dismiss() }
                Spacer()
            }
            .padding(20)
            .tint(Color(hex: "63B074"))
        }
        .navigationBarHidden(true)
    }
}
