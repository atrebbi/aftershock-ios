//
//  LogMessage.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 20/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

public class LogMessage {

    public let date: Date
    public let text: String

    init(date: Date, message: String) {
        self.date = date
        self.text = message
    }
}
