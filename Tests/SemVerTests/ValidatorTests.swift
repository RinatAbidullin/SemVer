//
//  ValidatorTests.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

import XCTest
@testable import SemVer

final class ValidatorTests: XCTestCase {
    func testSemVerValidate() throws {
        try Validator.validate(semVer: String(Validator.semVerAllowedChars))
    }

    func testIdentifiersValidate() throws {
        try Validator.validate(identifiers: [])
        try Validator.validate(identifiers: ["2512"])
        try Validator.validate(identifiers: ["sha", "hj12DGJh268lkqwDGH"])
        try Validator.validate(identifiers: ["2", "4", "15"])
        XCTAssertThrowsError(try Validator.validate(identifiers: ["sha.AFGSsdfs2512"]))
        XCTAssertThrowsError(try Validator.validate(identifiers: ["2", "04", "15"]))
    }

    func testVersionComponentsValidate() throws {
        XCTAssertEqual(try Validator.validate(version: "0"), 0)
        XCTAssertEqual(try Validator.validate(version: "5"), 5)
        XCTAssertThrowsError(try Validator.validate(version: "-1"))
        XCTAssertThrowsError(try Validator.validate(version: "01"))
    }
}
