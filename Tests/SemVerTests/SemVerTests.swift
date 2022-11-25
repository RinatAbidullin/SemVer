//
//  SemVerTests.swift
//
//
//  Created by Rinat Abidullin on 18.10.2022.
//

import XCTest
@testable import SemVer

final class SemVerTests: XCTestCase {
    func testMajorMinorPatch() throws {
        let version = try SemVer(string: "1.4.32")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testMajorMinorPatchPreRelease() throws {
        let version = try SemVer(string: "1.4.32-alpha")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testMajorMinorPatchBuild() throws {
        let version = try SemVer(string: "1.4.32+exp.sha.5114f85")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
    }

    func testMajorMinorPatchPreReleaseBuild() throws {
        let version = try SemVer(string: "1.4.32-alpha+1032")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["1032"])
    }

    func testMajorMinorPatchPreReleaseSeparatedBuild() throws {
        let version = try SemVer(string: "1.4.32-alpha+exp.sha.5114f85")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
    }

    func testMajorMinorPatchSeparatedPreReleaseBuild() throws {
        let version = try SemVer(string: "1.4.32-alpha.1.2+5114f85")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha", "1", "2"])
        XCTAssertEqual(version.buildIdentifiers, ["5114f85"])
    }

    func testSkippingPatch() throws {
        let version = try SemVer(string: "1.4", allowSkippingMinorOrPatch: true)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testSkippingMinorAndPatch() throws {
        let version = try SemVer(string: "1", allowSkippingMinorOrPatch: true)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testPreReleaseBuildSkippingPatch() throws {
        let version = try SemVer(string: "1.4-alpha+exp.sha.5114f85", allowSkippingMinorOrPatch: true)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
    }

    func testPreReleaseBuildSkippingMinorAndPatch() throws {
        let version = try SemVer(string: "3-alpha+exp.sha.5114f85", allowSkippingMinorOrPatch: true)
        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
    }

    func testStringRepresentation() throws {
        let version = try SemVer(major: 2, minor: 5, patch: 12, preReleaseIdentifiers: ["beta"], buildIdentifiers: ["exp", "sha", "5114f85"])
        XCTAssertEqual(version.asString, "2.5.12-beta+exp.sha.5114f85")
    }

    func testPreReleaseAndBuildIncludingHyphens() throws {
        let version = try SemVer(string: "1.4.32-alpha-beta+exp-sha-5114f85")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha-beta"])
        XCTAssertEqual(version.buildIdentifiers, ["exp-sha-5114f85"])
    }

    func testBuildIncludingHyphens() throws {
        let version = try SemVer(string: "1.4.32+exp-sha-5114f85")
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 32)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, ["exp-sha-5114f85"])
    }

    func testInvalidFormat() throws {
        XCTAssertThrowsError(try SemVer(string: "-1"))
        XCTAssertThrowsError(try SemVer(string: "+1"))
        XCTAssertThrowsError(try SemVer(string: "-1.4"))
        XCTAssertThrowsError(try SemVer(string: "+1.4"))
        XCTAssertThrowsError(try SemVer(string: "-1.4.32"))
        XCTAssertThrowsError(try SemVer(string: "+1.4.32"))
        XCTAssertThrowsError(try SemVer(string: "1.-4.32"))
        XCTAssertThrowsError(try SemVer(string: "1.+4.32"))
        XCTAssertThrowsError(try SemVer(string: "-1.4.32-alpha-beta+exp-sha-5114f85"))
        XCTAssertThrowsError(try SemVer(string: "+1.4.32-alpha-beta+exp-sha-5114f85"))
        XCTAssertThrowsError(try SemVer(string: "1.-4.32-alpha-beta+exp-sha-5114f85"))
        XCTAssertThrowsError(try SemVer(string: "1.+4.32-alpha-beta+exp-sha-5114f85"))
        XCTAssertThrowsError(try SemVer(string: "1.4.32-alpha+exp.sha..5114f85"))
        XCTAssertThrowsError(try SemVer(string: "1.4.32-alpha+exp.sha.02"))
        XCTAssertThrowsError(try SemVer(string: "1.4.32-alpha.01+exp.sha.ffff"))
        XCTAssertThrowsError(try SemVer(string: "v1.4.32"))
        XCTAssertThrowsError(try SemVer(string: "1.4.32-alpha+beta+exp-sha-5114f85"))
        XCTAssertThrowsError(try SemVer(string: "1.4."))
        XCTAssertThrowsError(try SemVer(string: "1.4.", allowSkippingMinorOrPatch: true))
        XCTAssertThrowsError(try SemVer(string: "1.4"))
        XCTAssertThrowsError(try SemVer(string: "1"))
        XCTAssertThrowsError(try SemVer(major: 2, minor: 5, patch: 12, preReleaseIdentifiers: ["beta"], buildIdentifiers: ["exp", "sha", "01"]))
    }
}
