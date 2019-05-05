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

    public static let DEFAULT_BINKP_PORT = 24554
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

    public static func retrieveSettings() throws {

        let settings: InstanceSettings = InstanceSettings()

        if let result = UserDefaults.standard.string(forKey: Keys.sysopName) {
            settings.sysopName = result.trimmingCharacters(in: .whitespaces)
            if settings.sysopName.isEmpty {
                throw SettingsError.noSysopName
            }
            if settings.sysopName.utf8.count > MAX_NAME_LENGTH {
                throw SettingsError.sysopNameTooLong
            }
        } else {
            throw SettingsError.noSysopName
        }

        if let result = UserDefaults.standard.string(forKey: Keys.stationName) {
            settings.stationName = result.trimmingCharacters(in: .whitespaces)
            if settings.stationName.isEmpty {
                throw SettingsError.noStationName
            }
            if settings.stationName.utf8.count > MAX_STATION_LENGTH {
                throw SettingsError.stationNameTooLong
            }
        } else {
            throw SettingsError.noStationName
        }

        if let result = UserDefaults.standard.string(forKey: Keys.location) {
            settings.location = result.trimmingCharacters(in: .whitespaces)
            if (settings.location.isEmpty) {
                throw SettingsError.noLocation
            }
            if settings.location.utf8.count > MAX_LOCATION_LENGTH {
                throw SettingsError.locationTooLong
            }
        } else {
            throw SettingsError.noLocation
        }

        if let result = UserDefaults.standard.string(forKey: Keys.ftnAddrs) {
            let txtAddresses = result.split(separator: " ", maxSplits: Int.max,
                                omittingEmptySubsequences: true)
            if txtAddresses.count == 0 {
                throw SettingsError.noSystemAddress
            }
            settings.ftnAddresses.reserveCapacity(txtAddresses.count)
            for txtAddress in txtAddresses {
                do {
                    let address = try FTNAddress(address: String(txtAddress))
                    settings.ftnAddresses.append(address)
                } catch {
                    throw SettingsError.badSystemAddress
                }
            }
        } else {
            throw SettingsError.noSystemAddress
        }

        if let result = UserDefaults.standard.string(forKey: Keys.ndlAttrs) {
            settings.nodelistAttributes =
                result.trimmingCharacters(in: .whitespaces)
            for char in settings.nodelistAttributes.utf8 {
                // non-control ASCII excluding dot //
                if (char <= 32 || char >= 127 || char == 46) {
                    throw SettingsError.badNodelistAttributes
                }
            }
        } else {
            settings.nodelistAttributes = "";
        }

        if let result = UserDefaults.standard.string(forKey: Keys.uplinkFtn) {
            let txtAddress = result.trimmingCharacters(in: .whitespaces)
            if txtAddress.isEmpty {
                throw SettingsError.noUplinkFtnAddr
            }
            do {
                settings.uplinkFtnAddress = try FTNAddress(address: txtAddress)
            } catch {
                throw SettingsError.badUplinkFtnAddr
            }
        } else {
            throw SettingsError.noUplinkFtnAddr
        }

        if let result = UserDefaults.standard.string(forKey: Keys.uplinkInet) {
            settings.uplinkInetAddress =
                result.trimmingCharacters(in: .whitespaces)
            if settings.uplinkInetAddress.isEmpty {
                throw SettingsError.noUplinkInetAddr
            }
            for char in settings.uplinkInetAddress.utf8 {
                // simple check for space symbols only //
                if (char == 32) {
                    throw SettingsError.badUplinkInetAddr
                }
            }
        } else {
            throw SettingsError.noUplinkInetAddr
        }

        if let result = UserDefaults.standard.string(forKey: Keys.uplinkPort) {
            let txtPort = result.trimmingCharacters(in: .whitespaces)
            if txtPort.isEmpty {
                settings.uplinkInetPort = DEFAULT_BINKP_PORT
            } else {
                if let port = Int(txtPort) {
                    if port < 0 || port > 65535 {
                        throw SettingsError.badUplinkInetPort
                    }
                    settings.uplinkInetPort = port
                } else {
                    throw SettingsError.badUplinkInetPort
                }
            }
        } else {
            settings.uplinkInetPort = DEFAULT_BINKP_PORT
        }

        settings.uplinkPassword =
            UserDefaults.standard.string(forKey: Keys.uplinkPassword) ?? ""

        settings.origin =
            UserDefaults.standard.string(forKey: Keys.origin) ?? ""
        if settings.origin.count > MAX_ORIGIN_LENGTH {
            throw SettingsError.originTooLong
        }

        settings.tearline =
            UserDefaults.standard.string(forKey: Keys.tearline) ?? ""
        if settings.tearline.count > MAX_TEARLINE_LENGTH {
            throw SettingsError.tearlineTooLong
        }

        settings.codepage = UserDefaults.standard
            .string(forKey: Keys.codepage) ?? DEFAULT_CODEPAGE;

        let result = UserDefaults.standard
            .string(forKey: Keys.replaceRussianN) ?? DEFAULT_REPLACE_N
        settings.replaceRussianN = result == "yes"

        settings.newMessageHeader =  UserDefaults.standard
            .string(forKey: Keys.newMessageHeader) ?? ""

        settings.replyHeader = UserDefaults.standard
            .string(forKey: Keys.replyHeader) ?? ""

        settings.signature = UserDefaults.standard
            .string(forKey: Keys.signature) ?? ""

        if let fontSize = UserDefaults.standard.string(forKey: Keys.fontSize) {
            settings.fontSize = Int(fontSize) ?? DEFAULT_FONT_SIZE
        } else {
            settings.fontSize = DEFAULT_FONT_SIZE
        }

        if let v = UserDefaults.standard.string(forKey: Keys.maxMsgNumber) {
            if let maxMsgNumber = Int(v) {
                if maxMsgNumber < 0 {
                    throw SettingsError.badMaxMsgNumber
                }
                settings.maxMsgNumber = maxMsgNumber
            } else {
                throw SettingsError.badMaxMsgNumber
            }
        } else {
            settings.maxMsgNumber = DEFAULT_MAX_MESSAGES
        }

        GlobalSettings.instance.settings = settings
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
