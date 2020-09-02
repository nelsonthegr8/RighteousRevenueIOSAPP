//
//  CheckIfUserWantsMonthlyReminders.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/23/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UserNotifications

public func SetUpTheMonthlyNotification(day: Int){
    
    if(UserDefaults.standard.bool(forKey: "MonthlyNotifications")){
        let center = UNUserNotificationCenter.current()
        //step 2 create notification content
        let content = UNMutableNotificationContent()
        content.title = "Hey Pay Your Bills"
        content.body = "Nah Fr. You should really pay your bills"
        content.sound = UNNotificationSound.default

        // Step 3: create notification trigger
        var newAlertMonth = DateComponents()
        newAlertMonth.calendar = Calendar.current
        //newAlertMonth.weekOfMonth = 1
        newAlertMonth.day = day
        newAlertMonth.hour = 9
        newAlertMonth.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: newAlertMonth, repeats: true)
        //create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        // Register the request to notification center
        center.removeAllPendingNotificationRequests()
        center.add(request) { (error) in
        // Check and handle errors
        }
        
    }

}
    

