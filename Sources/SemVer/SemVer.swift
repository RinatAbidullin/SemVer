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

    public let preReleaseIdentifiers: [String]
    public let buildIdentifiers: [String]

    public init(
        major: Int,
        minor: Int,
        patch: Int,
        preReleaseIdentifiers: [String] = [],
        buildIdentifiers: [String] = []
    ) throws {
        guard major >= 0, minor >= 0, patch >= 0 else { throw SemVerError.invalidFormat }
        self.major = major
        self.minor = minor
        self.patch = patch

        try Validator.validate(identifiers: preReleaseIdentifiers)
        self.preReleaseIdentifiers = preReleaseIdentifiers

        try Validator.validate(identifiers: buildIdentifiers)
        self.buildIdentifiers = buildIdentifiers
    }
}
