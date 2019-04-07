//
//  FTNAddress.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 24/03/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

/// A FRL-1002 compliant Fidonet address
public class FTNAddress {

    public static let defaultZone = 1;
    public static let defaultDomain = "fidonet";

    enum FTNAddressError: Error {
        case missingNetworkField
        case extraSlashCharacter
        case extraColonCharacter
        case invalidZoneValue
        case invalidNetValue
        case extraAtCharacter
        case extraDotCharacter
        case invalidPointValue
        case invalidNodeValue
        case zoneOutOfRange
        case netOutOfRange
        case nodeOutOfRange
        case pointOutOfRange
        case domainTooLong
        case domainWithInvalidCharacters
    }

    var zone: Int
    var net: Int
    var node: Int
    var point: Int
    var domain: String

    init() {
        zone = FTNAddress.defaultZone
        net = 0
        node = 0
        point = 0
        domain = FTNAddress.defaultDomain
    }

    /// Init object from textual representation of FTN address
    init(address: String) throws {

        // FTN address has two required fields: network //
        // and node. They are separated by slash symbol //
        let parts = address.components(separatedBy: "/");

        if parts.count < 1 {
            throw FTNAddressError.missingNetworkField
        }

        if parts.count > 2 {
            throw FTNAddressError.extraSlashCharacter
        }

        // First element of array contains optional //
        // zone and network divided by colon symbol //
        let zoneAndNet = parts[0].components(separatedBy: ":")

        if zoneAndNet.count > 2 {
            throw FTNAddressError.extraColonCharacter
        }

        if zoneAndNet.count == 2 {
            // Both zone and net are present //
            if let parsedZone = Int(zoneAndNet[0]) {
                zone = parsedZone
            } else {
                throw FTNAddressError.invalidZoneValue
            }

            if let parsedNet = Int(zoneAndNet[1]) {
                net = parsedNet
            } else {
                throw FTNAddressError.invalidNetValue
            }

        } else {
            // Only net is specified in the address //
            zone = FTNAddress.defaultZone
            if let parsedNet = Int(zoneAndNet[0]) {
                net = parsedNet
            } else {
                throw FTNAddressError.invalidNetValue
            }
        }

        // Now parse node, optinal point and optional domain //
        let addrAndDomain = parts[1].components(separatedBy: "@")
        if addrAndDomain.count > 2 {
            throw FTNAddressError.extraAtCharacter
        }

        if addrAndDomain.count == 2 {
            // Domain is specified in the address //
            domain = addrAndDomain[1]
        } else {
            domain = FTNAddress.defaultDomain
        }

        // Finally, get node and optional point fields //
        let nodeAndPoint = addrAndDomain[0].components(separatedBy: ".")
        if nodeAndPoint.count > 2 {
            throw FTNAddressError.extraDotCharacter
        }

        if (nodeAndPoint.count == 2) {
            // point field present in the address //
            if let parsedPoint = Int(nodeAndPoint[1]) {
                point = parsedPoint
            } else {
                throw FTNAddressError.invalidPointValue
            }
        } else {
            point = 0
        }

        if let parsedNode = Int(nodeAndPoint[0]) {
            node = parsedNode
        } else {
            throw FTNAddressError.invalidNodeValue
        }

        // Unfortunately, observers cannot throw errors. //
        // So, do some validation after address parsing. //
        if zone < 1 || zone > 32767 {
            throw FTNAddressError.zoneOutOfRange
        }

        if net < 1 || net > 32767 {
            throw FTNAddressError.netOutOfRange
        }

        if node < -1 || node > 32767 {
            throw FTNAddressError.nodeOutOfRange
        }

        if point < 0 || point > 32767 {
            throw FTNAddressError.pointOutOfRange
        }

        if domain.count > 8 {
            throw FTNAddressError.domainTooLong
        }

        for char in domain.utf8 {
            // non-control ASCII excluding dot //
            if (char <= 32 || char >= 127 || char == 46) {
                throw FTNAddressError.domainWithInvalidCharacters
            }
        }
    }
}
