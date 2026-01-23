//
//  MessagingManager.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//
import Foundation
import Firebase
import FirebaseMessaging
import UserNotifications

class MessagingManager: NSObject, ObservableObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    @Published var messages: [String] = []

    override init() {
        super.init()
        // Set up Firebase Messaging delegate
        Messaging.messaging().delegate = self
        // Set up Notification Center delegate
        UNUserNotificationCenter.current().delegate = self
        // Request notification permissions
        requestNotificationPermission()
    }

    // Request notification permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    // MARK: - UNUserNotificationCenterDelegate Methods

    // Handle foreground notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let message = userInfo["message"] as? String {
            DispatchQueue.main.async {
                self.messages.append("[AGENT] \(message)")
            }
        }
        completionHandler([.banner, .sound]) // iOS 14 and above
    }

    // Handle notification tap (background or terminated state)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let message = userInfo["message"] as? String {
            DispatchQueue.main.async {
                self.messages.append("[AGENT] \(message)")
            }
        }
        completionHandler()
    }

    // MARK: - MessagingDelegate Methods

    // Called when FCM token is updated
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Handle the new token if needed (e.g., send to your server)
        print("FCM registration token: \(String(describing: fcmToken))")
    }
}
