//
//  SemVerComparableTests.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

import XCTest
@testable import SemVer

typealias ComparableSemVers = (lhs: SemVer, rhs: SemVer)

final class SemVerComparableTests: XCTestCase {
    func testLess() throws {
        let vers: [ComparableSemVers] = [
            (
                lhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 4, minor: 2, patch: 18, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 4, minor: 3, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 5, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 1, minor: 0, patch: 0, preReleaseIdentifiers: ["alpha"], buildIdentifiers: []),
                rhs: try SemVer(major: 1, minor: 0, patch: 0, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(string: "1.0.0-alpha"),
                rhs: try SemVer(string: "1.0.0-alpha.1")
            ),
            (
                lhs: try SemVer(string: "1.0.0-alpha.1"),
                rhs: try SemVer(string: "1.0.0-alpha.beta")
            ),
            (
                lhs: try SemVer(string: "1.0.0-alpha.beta"),
                rhs: try SemVer(string: "1.0.0-beta")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta"),
                rhs: try SemVer(string: "1.0.0-beta.2")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta.2"),
                rhs: try SemVer(string: "1.0.0-beta.11")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta.11"),
                rhs: try SemVer(string: "1.0.0-rc.1")
            ),
            (
                lhs: try SemVer(string: "1.0.0-rc.1"),
                rhs: try SemVer(string: "1.0.0")
            ),
            (
                lhs: try SemVer(string: "1.0.0-2.3.5"),
                rhs: try SemVer(string: "1.0.0-2.3.6")
            ),
            (
                lhs: try SemVer(string: "1.0.0-2.5.9"),
                rhs: try SemVer(string: "1.0.0-3.3.6")
            ),
        ]

        for ver in vers {
            XCTAssertTrue(ver.lhs < ver.rhs)
        }
    }

    func testGreater() throws {
        let vers: [ComparableSemVers] = [
            (
                lhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 4, minor: 2, patch: 15, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 4, minor: 3, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 5, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 4, minor: 2, patch: 17, preReleaseIdentifiers: [], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(major: 1, minor: 0, patch: 0, preReleaseIdentifiers: [], buildIdentifiers: []),
                rhs: try SemVer(major: 1, minor: 0, patch: 0, preReleaseIdentifiers: ["alpha"], buildIdentifiers: [])
            ),
            (
                lhs: try SemVer(string: "1.0.0-alpha.3"),
                rhs: try SemVer(string: "1.0.0-alpha")
            ),
            (
                lhs: try SemVer(string: "1.0.0-alpha.beta"),
                rhs: try SemVer(string: "1.0.0-alpha.23")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta"),
                rhs: try SemVer(string: "1.0.0-alpha.beta")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta.5"),
                rhs: try SemVer(string: "1.0.0-beta")
            ),
            (
                lhs: try SemVer(string: "1.0.0-beta.12"),
                rhs: try SemVer(string: "1.0.0-beta.9")
            ),
            (
                lhs: try SemVer(string: "1.0.0-rc.1"),
                rhs: try SemVer(string: "1.0.0-beta.11")
            ),
            (
                lhs: try SemVer(string: "1.0.0"),
                rhs: try SemVer(string: "1.0.0-rc.1")
            ),
            (
                lhs: try SemVer(string: "1.0.0-2.3.6"),
                rhs: try SemVer(string: "1.0.0-2.3.5")
            ),
            (
                lhs: try SemVer(string: "1.0.0-2.4.4"),
                rhs: try SemVer(string: "1.0.0-2.3.5")
            ),
        ]

        for ver in vers {
            XCTAssertTrue(ver.lhs > ver.rhs)
        }
    }

    func testEqual() throws {
        let vers: [ComparableSemVers] = [
            (
                lhs: try SemVer(string: "1.0.0-rc.1+123365.FGSgTf.67"),
                rhs: try SemVer(string: "1.0.0-rc.1+123365.FGSgTf.67")
            ),
            (
                lhs: try SemVer(string: "1.0.0-rc.1+sha.f00000000000"),
                rhs: try SemVer(string: "1.0.0-rc.1+123365.FGSgTf.67")
            ),
            (
                lhs: try SemVer(string: "1.0.0"),
                rhs: try SemVer(string: "1.0.0")
            ),
        ]

        for ver in vers {
            XCTAssertFalse(ver.lhs > ver.rhs)
            XCTAssertFalse(ver.lhs < ver.rhs)
        }
    }
}
