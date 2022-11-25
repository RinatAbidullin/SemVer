//
//  SemVer+InitFromString.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

import Foundation

extension SemVer {
    public init(string: String, allowSkippingMinorOrPatch: Bool = false) throws {
        try Validator.validate(semVer: string)

        guard !(string.hasPrefix("-") || string.hasPrefix("+")) else {
            throw SemVerError.invalidFormat
        }

        let versionPreReleaseAndBuild = string
            .split(separator: "+", maxSplits: 1)
            .map { substring in
                String(substring)
            }

        guard versionPreReleaseAndBuild.count <= 2 else { throw SemVerError.invalidFormat }

        var build: [String] = []
        if versionPreReleaseAndBuild.count == 2 {
            build = versionPreReleaseAndBuild[1].components(separatedBy: ".")
        }

        let versionAndPreRelease = versionPreReleaseAndBuild[0]
            .split(separator: "-", maxSplits: 1)
            .map { substring in
                String(substring)
            }

        guard versionAndPreRelease.count <= 2 else { throw SemVerError.invalidFormat }

        var preRelease: [String] = []
        if versionAndPreRelease.count == 2 {
            preRelease = versionAndPreRelease[1].components(separatedBy: ".")
        }

        let version = versionAndPreRelease[0].components(separatedBy: ".")

        guard version.count > 0 && version.count <= 3 else { throw SemVerError.invalidFormat }

        guard allowSkippingMinorOrPatch || version.count == 3 else {
            throw SemVerError.invalidFormat
        }

        var major = 0
        var minor = 0
        var patch = 0
        if version.count >= 1 {
            major = try Validator.validate(version: version[0])
        }
        if version.count >= 2 {
            minor = try Validator.validate(version: version[1])
        }
        if version.count >= 3 {
            patch = try Validator.validate(version: version[2])
        }

        try self.init(major: major, minor: minor, patch: patch, preReleaseIdentifiers: preRelease, buildIdentifiers: build)
    }
}
