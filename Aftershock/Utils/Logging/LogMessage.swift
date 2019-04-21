//
//  LogMessage.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 20/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

public class LogMessage {

    public let timestamp: TimeInterval
    public let text: String

    init(timestamp: TimeInterval, message: String) {
        self.timestamp = timestamp
        self.text = message
    }
}
