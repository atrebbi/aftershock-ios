//
//  AoplicationSettings.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 29/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

/// A holder of settings for tasks instances.
/// It allows any task to have immutable set of settings
/// for its lifetime. This prevents from changing settins
/// while some task is active which in turn may cause
/// undefined task behaviour.
class InstanceSettings {
    var sysopName = ""
    var stationName = ""
    var location = ""
    var ftnAddresses: [FTNAddress] = []
    var nodelistAttributes = ""
    var uplinkFtnAddress: FTNAddress = FTNAddress()
    var uplinkInetAddress = ""
    var uplinkInetPort = 0
    var uplinkPassword = ""
    var origin = ""
    var tearline = ""
    var codepage = SettingsHelper.DEFAULT_CODEPAGE
    var replaceRussianN = true
    var newMessageHeader = ""
    var replyHeader = ""
    var signature = ""
    var fontSize = SettingsHelper.DEFAULT_FONT_SIZE
    var maxMsgNumber = SettingsHelper.DEFAULT_MAX_MESSAGES

    init() {
    }

    init(_ otherSettings: InstanceSettings) {
        sysopName = otherSettings.sysopName
        stationName = otherSettings.stationName
        location = otherSettings.location
        // "manual" deep copy of addresses array //
        ftnAddresses.removeAll()
        ftnAddresses.reserveCapacity(otherSettings.ftnAddresses.count)
        for address in otherSettings.ftnAddresses {
            ftnAddresses.append(FTNAddress(address))
        }
        nodelistAttributes = otherSettings.nodelistAttributes
        uplinkFtnAddress = FTNAddress(otherSettings.uplinkFtnAddress)
        uplinkInetAddress = otherSettings.uplinkInetAddress
        uplinkInetPort = otherSettings.uplinkInetPort
        uplinkPassword = otherSettings.uplinkPassword
        origin = otherSettings.origin
        tearline = otherSettings.tearline
        codepage = otherSettings.codepage
        replaceRussianN = otherSettings.replaceRussianN
        newMessageHeader = otherSettings.newMessageHeader
        replyHeader = otherSettings.replyHeader
        signature = otherSettings.signature
        fontSize = otherSettings.fontSize
        maxMsgNumber = otherSettings.maxMsgNumber
    }
}
