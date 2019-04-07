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

    struct CorrectSample {
        let textValue : String
        let zone: Int
        let net: Int
        let node: Int
        let point: Int
        let domain: String
    }

    struct IncorrectSample {
        let textValue: String
        let error: FTNAddress.FTNAddressError
    }

    var correctSamples: [CorrectSample] = [
        CorrectSample(textValue: "1:234/5.6@fidonet", zone: 1, net: 234, node: 5, point: 6, domain: "fidonet"),
        CorrectSample(textValue: "2:34/6.78", zone: 2, net: 34, node: 6, point: 78, domain: "fidonet"),
        CorrectSample(textValue: "4:610/34", zone: 4, net: 610, node: 34, point: 0, domain: "fidonet"),
        CorrectSample(textValue: "123/45", zone: 1, net: 123, node: 45, point: 0, domain: "fidonet"),
        CorrectSample(textValue: "123/45.0", zone: 1, net: 123, node: 45, point: 0, domain: "fidonet"),
        CorrectSample(textValue: "955:95/2@othernet", zone: 955, net: 95, node: 2, point: 0, domain: "othernet"),
        CorrectSample(textValue: "2:259/-1", zone: 2, net: 259, node: -1, point: 0, domain: "fidonet")
    ]

    var incorrectSamples: [IncorrectSample] = [
        IncorrectSample(textValue: "0:123/4.1", error: .zoneOutOfRange),
        IncorrectSample(textValue: "32768:123/4.1", error: .zoneOutOfRange),
        IncorrectSample(textValue: "2:0/6.78", error: .netOutOfRange),
        IncorrectSample(textValue: "2:32768/6.78", error: .netOutOfRange),
        IncorrectSample(textValue: "2:34/-2.78", error: .nodeOutOfRange),
        IncorrectSample(textValue: "2:34/32768.78", error: .nodeOutOfRange),
        IncorrectSample(textValue: "2:34/6.-1", error: .pointOutOfRange),
        IncorrectSample(textValue: "2:34/6.32768", error: .pointOutOfRange),
        IncorrectSample(textValue: "1:123/4.1@verylongdomain", error: .domainTooLong),
        IncorrectSample(textValue: "1:123/4.1@dom.dot", error: .domainWithInvalidCharacters),
        IncorrectSample(textValue: "1:123/4.1@huh░", error: .domainWithInvalidCharacters),
    ]

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCorrectValues() {
        for sample in correctSamples {
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

    func testIncorrentValues() {
        for sample in incorrectSamples {
            XCTAssertThrowsError(try FTNAddress(address: sample.textValue),
                                 "Expected \(sample.error) error") { (error) in
                XCTAssertEqual(error as? FTNAddress.FTNAddressError,
                               sample.error, "Expected another error")
            }
        }
    }
}
