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
        let version = try SemVer(string: "1.4", options: [.allowSkippingMinorOrPatch])
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testSkippingMinorAndPatch() throws {
        let version = try SemVer(string: "1", options: [.allowSkippingMinorOrPatch])
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, [])
        XCTAssertEqual(version.buildIdentifiers, [])
    }

    func testPreReleaseBuildSkippingPatch() throws {
        let version = try SemVer(
            string: "1.4-alpha+exp.sha.5114f85",
            options: [.allowSkippingMinorOrPatch]
        )
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 4)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
    }

    func testPreReleaseBuildSkippingMinorAndPatch() throws {
        let version = try SemVer(
            string: "3-alpha+exp.sha.5114f85",
            options: [.allowSkippingMinorOrPatch]
        )
        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.preReleaseIdentifiers, ["alpha"])
        XCTAssertEqual(version.buildIdentifiers, ["exp", "sha", "5114f85"])
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
        XCTAssertThrowsError(try SemVer(string: "1.4.", options: [.allowSkippingMinorOrPatch]))
        XCTAssertThrowsError(try SemVer(string: "1.4"))
        XCTAssertThrowsError(try SemVer(string: "1"))
        XCTAssertThrowsError(
            try SemVer(
                major: 2,
                minor: 5,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "sha", "01"]
            )
        )
    }

    func testStringRepresentationWithoutOptions() throws {
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 5,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "sha", "5114f85"]
            )
            .asString,
            "2.5.12-beta+exp.sha.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 5,
                patch: 12
            )
            .asString,
            "2.5.12"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 5,
                patch: 0
            )
            .asString,
            "2.5.0"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0
            )
            .asString,
            "2.0.0"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 1,
                patch: 0
            )
            .asString,
            "0.1.0"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 3
            )
            .asString,
            "0.0.3"
        )
    }

    func testStringRepresentationWithOptions() throws {
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible
            ]),
            "2.0.12-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible
            ]),
            "2.0.12-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible
            ]),
            "2-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible
            ]),
            "2-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPatchIfPossible
            ]),
            "2.0-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: []),
            "2.0.0-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible
            ]),
            "0.0.12-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible
            ]),
            "0.0.12-beta+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 7,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible
            ]),
            "0.7-beta+exp.5114f85"
        )

        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease
            ]),
            "2.0.12+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease
            ]),
            "2.0.12+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease
            ]),
            "2+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease
            ]),
            "2+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPatchIfPossible,
                .omitPreRelease
            ]),
            "2.0+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPreRelease
            ]),
            "2.0.0+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease
            ]),
            "0.0.12+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease
            ]),
            "0.0.12+exp.5114f85"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 7,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease
            ]),
            "0.7+exp.5114f85"
        )

        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitBuild
            ]),
            "2.0.12-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitBuild
            ]),
            "2.0.12-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitBuild
            ]),
            "2-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitBuild
            ]),
            "2-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPatchIfPossible,
                .omitBuild
            ]),
            "2.0-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitBuild
            ]),
            "2.0.0-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitBuild
            ]),
            "0.0.12-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitBuild
            ]),
            "0.0.12-beta"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 7,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitBuild
            ]),
            "0.7-beta"
        )

        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "2.0.12"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "2.0.12"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "2"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "2"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "2.0"
        )
        XCTAssertEqual(
            try SemVer(
                major: 2,
                minor: 0,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitPreRelease,
                .omitBuild
            ]),
            "2.0.0"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "0.0.12"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 0,
                patch: 12,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "0.0.12"
        )
        XCTAssertEqual(
            try SemVer(
                major: 0,
                minor: 7,
                patch: 0,
                preReleaseIdentifiers: ["beta"],
                buildIdentifiers: ["exp", "5114f85"]
            )
            .asString(with: [
                .omitMinorAndPatchIfPossible,
                .omitPatchIfPossible,
                .omitPreRelease,
                .omitBuild
            ]),
            "0.7"
        )
    }
}
