//
//  SemVer.swift
//
//
//  Created by Rinat Abidullin on 18.10.2022.
//

public struct SemVer {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public let preRelease: [String]
    public let build: [String]

    public var asString: String {
        var version = "\(major).\(minor).\(patch)"
        if !preRelease.isEmpty {
            version.append("-\(preRelease.joined(separator: "."))")
        }
        if !build.isEmpty {
            version.append("+\(build.joined(separator: "."))")
        }
        return version
    }

    public init(
        major: Int,
        minor: Int,
        patch: Int,
        preRelease: [String] = [],
        build: [String] = []
    ) throws {
        guard major >= 0, minor >= 0, patch >= 0 else { throw SemVerError.invalidFormat }
        self.major = major
        self.minor = minor
        self.patch = patch

        try Validator.validate(identifiers: preRelease)
        self.preRelease = preRelease

        try Validator.validate(identifiers: build)
        self.build = build
    }
}
