//
//  SettingsHelper.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 21/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

class SettingsHelper {

    public static let MAX_NAME_LENGTH = 36
    public static let MAX_STATION_LENGTH = 64
    public static let MAX_LOCATION_LENGTH = 72
    public static let MAX_ORIGIN_LENGTH = 56
    public static let MAX_TEARLINE_LENGTH = 64

    public static let DEFAULT_BINKP_PORT = "24554"
    public static let DEFAULT_CODEPAGE = "auto"
    public static let DEFAULT_REPLACE_N = "yes"
    public static let DEFAULT_FONT_SIZE = 12
    public static let DEFAULT_MAX_MESSAGES = 300

    /// Settings validation errors
    public enum SettingsError: Error {
        case noSysopName
        case sysopNameTooLong
        case noStationName
        case stationNameTooLong
        case noLocation
        case locationTooLong
        case noSystemAddress
        case badSystemAddress
        case badNodelistAttributes
        case noUplinkFtnAddr
        case badUplinkFtnAddr
        case noUplinkInetAddr
        case badUplinkInetAddr
        case noUplinkInetPort
        case badUplinkInetPort
        case originTooLong
        case tearlineTooLong
        case badMaxMsgNumber
    }

    /// Keys of settings for accessing user defaults
    public struct Keys {
        static let sysopName = "sysopName"
        static let stationName = "stationName"
        static let location = "location"
        static let ftnAddrs = "ftnAddrs"
        static let ndlAttrs = "nodelistAttrs"
        static let uplinkFtn = "uplinkFtnAddr"
        static let uplinkInet = "uplinkInetAddr"
        static let uplinkPort = "uplinkInetPort"
        static let uplinkPassword = "uplinkPassword"
        static let origin = "origin"
        static let tearline = "tearline"
        static let codepage = "codepage"
        static let replaceRussianN = "replaceN"
        static let newMessageHeader = "newmsghead"
        static let replyHeader = "replymsghead"
        static let signature = "signature"
        static let fontSize = "msgFontSize"
        static let maxMsgNumber = "maxMessagesNumber"
    }

    public static func getSysopName() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.sysopName) {
             return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }

    public static func getSystemName() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.stationName) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }

    public static func getLocation() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.location) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil
        }
    }

    public static func getFTNAddresses() -> [Substring]? {
        if let result = UserDefaults.standard.string(forKey: Keys.ftnAddrs) {
            return result.split(separator: " ", maxSplits: Int.max,
                                omittingEmptySubsequences: true)
        } else {
            return nil;
        }
    }

    public static func getNodelistAttributes() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.ndlAttrs) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil;
        }
    }

    public static func getUplinkFTNAddress() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.uplinkFtn) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil;
        }
    }

    public static func getUplinkInetAddress() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.uplinkInet) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return nil;
        }
    }

    public static func getUplinkInetPort() -> String? {
        if let result = UserDefaults.standard.string(forKey: Keys.uplinkPort) {
            return result.trimmingCharacters(in: .whitespaces)
        } else {
            return DEFAULT_BINKP_PORT;
        }
    }

    public static func getUplinkPassword() -> String? {
        return UserDefaults.standard.string(forKey: Keys.uplinkPassword)
    }

    public static func getOrigin() -> String? {
        return UserDefaults.standard.string(forKey: Keys.origin)
    }

    public static func getTearline() -> String? {
        return UserDefaults.standard.string(forKey: Keys.tearline)
    }

    public static func getCodepage() -> String {
        return UserDefaults.standard
            .string(forKey: Keys.codepage) ?? DEFAULT_CODEPAGE;
    }

    public static func replaceRussianN() -> Bool {
        let result = UserDefaults.standard
            .string(forKey: Keys.replaceRussianN) ?? DEFAULT_REPLACE_N
        return result == "yes"
    }

    public static func getNewMessageHeader() -> String? {
        return UserDefaults.standard.string(forKey: Keys.newMessageHeader)
    }

    public static func getReplyHeader() -> String? {
        return UserDefaults.standard.string(forKey: Keys.replyHeader)
    }

    public static func getSignature() -> String? {
        return UserDefaults.standard.string(forKey: Keys.signature)
    }

    public static func getFontSize() -> Int {
        if let fontSize = UserDefaults.standard.string(forKey: Keys.fontSize) {
            return Int(fontSize)!
        } else {
            return DEFAULT_FONT_SIZE
        }
    }

    public static func getDefaultMaxMessagesNumber() -> Int {
        if let v = UserDefaults.standard.string(forKey: Keys.maxMsgNumber) {
            return Int(v) ?? DEFAULT_MAX_MESSAGES
        } else {
            return DEFAULT_MAX_MESSAGES
        }
    }

    public static func validateSettings() throws {

        if let sysopName = SettingsHelper.getSysopName() {
            if sysopName.isEmpty {
                throw SettingsError.noSysopName
            }
            if sysopName.count > 36 {
                throw SettingsError.sysopNameTooLong
            }
        } else {
            throw SettingsError.noSysopName
        }

        if let systemName = SettingsHelper.getSystemName() {
            if systemName.isEmpty {
                throw SettingsError.noStationName
            }
            if systemName.count > MAX_STATION_LENGTH {
                throw SettingsError.stationNameTooLong
            }
        } else {
            throw SettingsError.noStationName
        }

        if let location = SettingsHelper.getLocation() {
            if (location.isEmpty) {
                throw SettingsError.noLocation
            }
            if location.count > MAX_LOCATION_LENGTH {
                throw SettingsError.locationTooLong
            }
        } else {
            throw SettingsError.noLocation
        }

        if let systemAddresses = SettingsHelper.getFTNAddresses() {
            if systemAddresses.count == 0 {
                throw SettingsError.noSystemAddress
            }
            for address in systemAddresses {
                do {
                    try _ = FTNAddress(address: String(address))
                } catch {
                    throw SettingsError.badSystemAddress
                }
            }
        } else {
            throw SettingsError.noSystemAddress
        }

        if let nodelistAttributes = SettingsHelper.getNodelistAttributes() {
            for char in nodelistAttributes.utf8 {
                // non-control ASCII excluding dot //
                if (char <= 32 || char >= 127 || char == 46) {
                    throw SettingsError.badNodelistAttributes
                }
            }
        }

        if let uplinkFtnAddress = SettingsHelper.getUplinkFTNAddress() {
            if uplinkFtnAddress.isEmpty {
                throw SettingsError.noUplinkFtnAddr
            }
            do {
                try _ = FTNAddress(address: String(uplinkFtnAddress))
            } catch {
                throw SettingsError.badUplinkFtnAddr
            }
        } else {
            throw SettingsError.noUplinkFtnAddr
        }

        if let uplinkInetAddress = SettingsHelper.getUplinkInetAddress() {
            if uplinkInetAddress.isEmpty {
                throw SettingsError.noUplinkInetAddr
            }
            for char in uplinkInetAddress.utf8 {
                // simple check for space symbols only //
                if (char == 32) {
                    throw SettingsError.badUplinkInetAddr
                }
            }
        } else {
            throw SettingsError.noUplinkInetAddr
        }

        if let uplinkInetPort = SettingsHelper.getUplinkInetPort() {
            if uplinkInetPort.isEmpty {
                throw SettingsError.noUplinkInetPort
            }
            if let port = Int(uplinkInetPort) {
                if port < 0 || port > 65535 {
                    throw SettingsError.badUplinkInetPort
                }
            } else {
                throw SettingsError.badUplinkInetPort
            }
        } else {
            throw SettingsError.noUplinkInetPort
        }

        if let origin = SettingsHelper.getOrigin() {
            if origin.count > MAX_ORIGIN_LENGTH {
                throw SettingsError.originTooLong
            }
        }

        if let tearline = SettingsHelper.getTearline() {
            if tearline.count > MAX_TEARLINE_LENGTH {
                throw SettingsError.tearlineTooLong
            }
        }

        if let v = UserDefaults.standard.string(forKey: Keys.maxMsgNumber) {
            if let maxMsgNumber = Int(v) {
                if maxMsgNumber < 0 {
                    throw SettingsError.badMaxMsgNumber
                }
            } else {
                throw SettingsError.badMaxMsgNumber
            }
        }
    }

    public static func getErrorMessage(error: SettingsError) -> String {
        switch error {
        case .noSysopName:
            return NSLocalizedString("User name is not specified", comment: "")
        case .sysopNameTooLong:
            return NSLocalizedString("User name must be no longer than 36 symbols", comment: "")
        case .noStationName:
            return NSLocalizedString("Station name is not specified", comment: "")
        case .stationNameTooLong:
            return NSLocalizedString("Station name is longer than 64 symbols", comment: "")
        case .noLocation:
            return NSLocalizedString("Primary location of the station if not specified", comment: "")
        case .locationTooLong:
            return NSLocalizedString("Primary station location is longer than 72 symbols", comment: "")
        case .noSystemAddress:
            return NSLocalizedString("FTN-addresses of the station are not specified", comment: "")
        case .badSystemAddress:
            return NSLocalizedString("Malformed FTN-addresses of the station", comment: "")
        case .badNodelistAttributes:
            return NSLocalizedString("Nodelist attributes contain disallowed characters", comment: "")
        case .noUplinkFtnAddr:
            return NSLocalizedString("FTN-addresses of uplink node is not specified", comment: "")
        case .badUplinkFtnAddr:
            return NSLocalizedString("Malformed FTN-addresses of uplink node", comment: "")
        case .noUplinkInetAddr:
            return NSLocalizedString("Uplink Inet address not set", comment: "")
        case .badUplinkInetAddr:
            return NSLocalizedString("Uplink inet address is incorrect", comment: "")
        case .noUplinkInetPort:
            return NSLocalizedString("Uplink TCP port is not set", comment: "")
        case .badUplinkInetPort:
            return NSLocalizedString("Incorrect uplink TCP port is specified", comment: "")
        case .originTooLong:
            return NSLocalizedString("Origin text must be not longer than 56 symbols", comment: "")
        case .tearlineTooLong:
            return NSLocalizedString("Tearline must be not longer than 64 symbols", comment: "")
        case .badMaxMsgNumber:
            return NSLocalizedString("Incorrect value of default maximum messages number", comment: "")
        }
    }
}
