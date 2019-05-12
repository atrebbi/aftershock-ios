//
//  NotificationHelper.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 12/05/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

public class NotificationHelper {

    // Set of all supported notification keywords //
    public enum Keyword: String {
        case log
        case settings
    }

    public static func sendNotification(keyword: Keyword) {

        let notification = Notification(
            name: Notification.Name(keyword.rawValue))
        NotificationCenter.default.post(notification)
    }
}
