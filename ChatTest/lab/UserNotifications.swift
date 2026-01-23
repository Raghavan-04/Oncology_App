//
//  UserNotifications.swift
//  ChatTest
//
//  Created by Raghavan on 29/09/24.
//

import UserNotifications

func scheduleNotification(labResult: LabResult) {
    let content = UNMutableNotificationContent()
    content.title = "Upcoming Lab Result"
    content.body = "\(labResult.testName) is pending on \(labResult.date)."
    content.sound = .default

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let resultDate = dateFormatter.date(from: labResult.date) {
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour], from: resultDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: labResult.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

// Call `scheduleNotification` for each upcoming lab result when the view appears
.onAppear {
    for result in labResults.filter({ $0.date > getCurrentDate() }) {
        scheduleNotification(labResult: result)
    }
}
