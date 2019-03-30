//
//  FTNAddressTest.swift
//  AftershockTests
//
//  Created by Anatoly Vdovichev on 25/03/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import XCTest
@testable import Aftershock

class FTNAddressTest: XCTestCase {

    struct Sample {
        let textValue : String
        let zone: Int
        let net: Int
        let node: Int
        let point: Int
        let domain: String
    }
    var samples: [Sample] = [
        Sample(textValue: "1:234/5.6@fidonet", zone: 1, net: 234, node: 5, point: 6, domain: "fidonet"),
        Sample(textValue: "2:34/6.78", zone: 2, net: 34, node: 6, point: 78, domain: "fidonet"),
        Sample(textValue: "4:610/34", zone: 4, net: 610, node: 34, point: 0, domain: "fidonet"),
        Sample(textValue: "123/45", zone: 1, net: 123, node: 45, point: 0, domain: "fidonet"),
        Sample(textValue: "955:95/2@othernet", zone: 955, net: 95, node: 2, point: 0, domain: "othernet"),
        Sample(textValue: "2:259/-1", zone: 2, net: 259, node: -1, point: 0, domain: "fidonet")
    ]

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCorrectValues() {
        for sample in samples {
            do {
                let ftnAddress = try FTNAddress(address: sample.textValue)
                XCTAssertEqual(ftnAddress.zone, sample.zone, "Zone parsed incorrectly")
                XCTAssertEqual(ftnAddress.net, sample.net, "Net parsed incorrectly")
                XCTAssertEqual(ftnAddress.node, sample.node, "Node parsed incorrectly")
                XCTAssertEqual(ftnAddress.point, sample.point, "Point parsed incorrectly")
                XCTAssertEqual(ftnAddress.domain, sample.domain, "Domain parsed incorrectly")
            } catch {
                assert(false, "Parsing failed for " + sample.textValue + ": \(error) ")
            }
        }
    }

    func testReusing() {
    }
}
