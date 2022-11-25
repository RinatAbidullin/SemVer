//
//  SemVerEquatableTests.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

import XCTest
@testable import SemVer

final class SemVerEquatableTests: XCTestCase {
    func testEqual() throws {
        XCTAssertEqual(
            try SemVer(major: 3, minor: 14, patch: 15),
            try SemVer(major: 3, minor: 14, patch: 15)
        )
        XCTAssertEqual(
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"]),
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"])
        )
        XCTAssertEqual(
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"], buildIdentifiers: ["1234"]),
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"], buildIdentifiers: ["5678"])
        )
    }

    func testNotEqual() throws {
        XCTAssertNotEqual(
            try SemVer(major: 2, minor: 0, patch: 0),
            try SemVer(major: 3, minor: 0, patch: 0)
        )
        XCTAssertNotEqual(
            try SemVer(major: 3, minor: 0, patch: 0),
            try SemVer(major: 3, minor: 1, patch: 0)
        )
        XCTAssertNotEqual(
            try SemVer(major: 3, minor: 14, patch: 15),
            try SemVer(major: 3, minor: 14, patch: 16)
        )
        XCTAssertNotEqual(
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"]),
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["beta"])
        )
        XCTAssertNotEqual(
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["alpha"], buildIdentifiers: ["1234"]),
            try SemVer(major: 3, minor: 14, patch: 15, preReleaseIdentifiers: ["beta"], buildIdentifiers: ["1234"])
        )
    }
}
