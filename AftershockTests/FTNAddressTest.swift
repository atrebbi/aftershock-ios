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
        let text : String
        let zone: Int
        let net: Int
        let node: Int
        let point: Int
        let domain: String
    }

    struct IncorrectSample {
        let text: String
        let error: FTNAddress.FTNAddressError
    }

    var correctSamples: [CorrectSample] = [
        CorrectSample(text: "1:234/5.6@fidonet", zone: 1, net: 234, node: 5, point: 6, domain: "fidonet"),
        CorrectSample(text: "2:34/6.78", zone: 2, net: 34, node: 6, point: 78, domain: "fidonet"),
        CorrectSample(text: "4:610/34", zone: 4, net: 610, node: 34, point: 0, domain: "fidonet"),
        CorrectSample(text: "123/45", zone: 1, net: 123, node: 45, point: 0, domain: "fidonet"),
        CorrectSample(text: "123/45.0", zone: 1, net: 123, node: 45, point: 0, domain: "fidonet"),
        CorrectSample(text: "955:95/2@othernet", zone: 955, net: 95, node: 2, point: 0, domain: "othernet"),
        CorrectSample(text: "2:259/-1", zone: 2, net: 259, node: -1, point: 0, domain: "fidonet"),
        CorrectSample(text: "2:259/67.8", zone: 2, net: 259, node: 67, point: 8, domain: "fidonet"),
        CorrectSample(text: "   2:259/67.8   ", zone: 2, net: 259, node: 67, point: 8, domain: "fidonet")
    ]

    var incorrectSamples: [IncorrectSample] = [
        IncorrectSample(text: "0:123/4.1", error: .zoneOutOfRange),
        IncorrectSample(text: "32768:123/4.1", error: .zoneOutOfRange),
        IncorrectSample(text: "2:0/6.78", error: .netOutOfRange),
        IncorrectSample(text: "2:32768/6.78", error: .netOutOfRange),
        IncorrectSample(text: "2:34/-2.78", error: .nodeOutOfRange),
        IncorrectSample(text: "2:34/32768.78", error: .nodeOutOfRange),
        IncorrectSample(text: "2:34/6.-1", error: .pointOutOfRange),
        IncorrectSample(text: "2:34/6.32768", error: .pointOutOfRange),
        IncorrectSample(text: "1:123/4.1@verylongdomain", error: .domainTooLong),
        IncorrectSample(text: "1:123/4.1@dom@dom", error: .extraAtCharacter),
        IncorrectSample(text: "1:123/4.1@dom.dot", error: .domainWithInvalidCharacters),
        IncorrectSample(text: "1:123/4.1@huh░", error: .domainWithInvalidCharacters),
        IncorrectSample(text: "abcd", error: .missingNodeField),
        IncorrectSample(text: "abcd/efgh", error: .invalidNetValue),
        IncorrectSample(text: "abcd/efgh/zxc", error: .extraSlashCharacter),
        IncorrectSample(text: "23.4/12d", error: .invalidNetValue),
        IncorrectSample(text: "23,4/12d", error: .invalidNetValue),
        IncorrectSample(text: "23-4/12d", error: .invalidNetValue),
        IncorrectSample(text: "23 /12d", error: .invalidNetValue),
        IncorrectSample(text: "234/12d", error: .invalidNodeValue),
        IncorrectSample(text: "234/12 .1", error: .invalidNodeValue),
        IncorrectSample(text: "1a:234/145", error: .invalidZoneValue),
        IncorrectSample(text: "1 :234/145", error: .invalidZoneValue),
        IncorrectSample(text: "1.1:234/145", error: .invalidZoneValue),
        IncorrectSample(text: "1:1:234/145", error: .extraColonCharacter),
        IncorrectSample(text: "1:234/145.76b", error: .invalidPointValue),
        IncorrectSample(text: "1:234/145.76.b", error: .extraDotCharacter),
    ]

    override func setUp() {
    }

    override func tearDown() {
    }

    func testCorrectValues() {
        for sample in correctSamples {
            do {
                let ftnAddress = try FTNAddress(address: sample.text)
                XCTAssertEqual(ftnAddress.zone, sample.zone, "Zone parsed incorrectly")
                XCTAssertEqual(ftnAddress.net, sample.net, "Net parsed incorrectly")
                XCTAssertEqual(ftnAddress.node, sample.node, "Node parsed incorrectly")
                XCTAssertEqual(ftnAddress.point, sample.point, "Point parsed incorrectly")
                XCTAssertEqual(ftnAddress.domain, sample.domain, "Domain parsed incorrectly")
            } catch {
                XCTAssert(false, "Parsing failed for [" + sample.text + "]: \(error) ")
            }
        }
    }

    func testIncorrentValues() {
        for sample in incorrectSamples {
            XCTAssertThrowsError(try FTNAddress(address: sample.text),
                                 "Expected \(sample.error) error") { (error) in
                XCTAssertEqual(error as? FTNAddress.FTNAddressError,
                               sample.error, sample.text + ": Expected another error")
            }
        }
    }
}
