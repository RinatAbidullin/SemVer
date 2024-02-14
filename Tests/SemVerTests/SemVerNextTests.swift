//
//  SemVerNextTests.swift
//
//
//  Created by Rinat Abidullin on 10.02.2024.
//

import XCTest
import SemVer

final class SemVerNextTests: XCTestCase {
    func testNextMajor() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        let newVersion = try version.next(.major)
        XCTAssertEqual(newVersion.asString, "2.0.0")
    }

    func testAnotherNextMajor() throws {
        let version = try SemVer(string: "0.0.98")
        let newVersion = try version.next(.major)
        XCTAssertEqual(newVersion.asString, "1.0.0")
    }

    func testNextMinor() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        let newVersion = try version.next(.minor)
        XCTAssertEqual(newVersion.asString, "1.5.0")
    }

    func testNextPatch() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        let newVersion = try version.next(.patch)
        XCTAssertEqual(newVersion.asString, "1.4.33")
        print(Int.max)
    }

    func testNextMajorWithKeepPreReleaseAndSetNewBuid() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        let newVersion = try version.next(.major, with: (preRelease: .keep, build: .setNew(["1"])))
        XCTAssertEqual(newVersion.asString, "2.0.0-alpha+1")
    }

    func testNextMajorWithSetNewPreReleaseAndKeepBuid() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        let newVersion = try version.next(.major, with: (preRelease: .setNew(["beta"]), build: .keep))
        XCTAssertEqual(newVersion.asString, "2.0.0-beta+1032")
    }

    func testOverflowNextMajor() throws {
        let version = try SemVer(string: "9223372036854775807.4.32-alpha+1032")
        XCTAssertThrowsError(try version.next(.major))
    }

    func testOverflowNextMinor() throws {
        let version = try SemVer(string: "1.9223372036854775807.32-alpha+1032")
        XCTAssertThrowsError(try version.next(.minor))
    }

    func testOverflowNextPatch() throws {
        let version = try SemVer(string: "1.4.9223372036854775807-alpha+1032")
        XCTAssertThrowsError(try version.next(.patch))
    }
}
