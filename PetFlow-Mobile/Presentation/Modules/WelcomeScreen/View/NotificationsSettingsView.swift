//
//  NotificationsSettingsView.swift
//  PetFlow-Mobile
//
//  Created by Stepan Kolenkin on 15.05.2026.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var pushEnabled = false
    @State private var email = false
    @State private var sms = false
    @State private var calls = false
    @State private var systemPushDenied = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Настройка уведомлений")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#4A37A7"))
                Spacer()
                Color.clear.frame(width: 20)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Push-уведомления")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 4)
                    
                    if systemPushDenied {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.slash.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Уведомления отключены")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Разрешите уведомления в настройках устройства")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button("Открыть") {
                                openSystemSettings()
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#4A37A7"))
                        }
                        .padding()
                        .background(Color.orange.opacity(0.08))
                        .cornerRadius(12)
                    } else {
                        toggleRow(
                            title: "Push уведомления",
                            subtitle: "Получать уведомления о записях",
                            icon: "bell.fill",
                            isOn: $pushEnabled
                        )
                        .onChange(of: pushEnabled) { _, newValue in
                            handlePushToggle(newValue)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Другие каналы")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 4)
                    
                    toggleRow(
                        title: "Email-уведомления",
                        subtitle: "Письма о статусе записи",
                        icon: "envelope.fill",
                        isOn: $email
                    )
                    toggleRow(
                        title: "SMS-уведомления",
                        subtitle: "Напоминания по SMS",
                        icon: "message.fill",
                        isOn: $sms
                    )
                    toggleRow(
                        title: "Телефонные звонки",
                        subtitle: "Звонки от клиники",
                        icon: "phone.fill",
                        isOn: $calls
                    )
                }
                VStack(spacing: 16) {
                    PrimaryButton(
                        title: "Сохранить изменения",
                        isSecondary: false
                    ) {
                        saveAndDismiss()
                    }
                    
                    PrimaryButton(
                        title: "Отправить тестовый пуш",
                        isSecondary: true
                    ) {
                        sendTestPush()
                    }
                    .disabled(!pushEnabled)
                    .opacity(pushEnabled ? 1.0 : 0.5)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Color(hex: "#F8F9FE"))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            checkPushStatus()
            loadSavedSettings()
        }
    }
    private func toggleRow(
        title: String,
        subtitle: String,
        icon: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#4A37A7").opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "#4A37A7"))
                    .font(.system(size: 18))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color(hex: "#63B074"))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
    }
    private func checkPushStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    pushEnabled = true
                    systemPushDenied = false
                case .denied:
                    pushEnabled = false
                    systemPushDenied = true
                case .notDetermined:
                    pushEnabled = false
                    systemPushDenied = false
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func handlePushToggle(_ enabled: Bool) {
        if enabled {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        UNUserNotificationCenter.current().requestAuthorization(
                            options: [.alert, .sound, .badge]
                        ) { granted, _ in
                            DispatchQueue.main.async {
                                pushEnabled = granted
                                systemPushDenied = !granted
                            }
                        }
                    case .denied:
                        pushEnabled = false
                        systemPushDenied = true
                    case .authorized, .provisional:
                        pushEnabled = true
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
    
    private func sendTestPush() {
        let content = UNMutableNotificationContent()
        content.title = "PetFlow 🐾"
        content.body = "Напоминание: запись в клинику завтра в 10:30"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 3,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("❌ Ошибка: \(error)")
            } else {
                print("✅ Пуш придёт через 3 секунды")
            }
        }
    }
    
    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func saveAndDismiss() {
        UserDefaults.standard.set(email, forKey: "notify_email")
        UserDefaults.standard.set(sms, forKey: "notify_sms")
        UserDefaults.standard.set(calls, forKey: "notify_calls")
        dismiss()
    }
    
    private func loadSavedSettings() {
        email = UserDefaults.standard.bool(forKey: "notify_email")
        sms = UserDefaults.standard.bool(forKey: "notify_sms")
        calls = UserDefaults.standard.bool(forKey: "notify_calls")
    }
}
