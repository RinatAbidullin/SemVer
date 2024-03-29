//
//  SemVer+Equatable.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

extension SemVer: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // Build игнорируется при сравнении, см. https://semver.org
        lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch &&
        lhs.preReleaseIdentifiers == rhs.preReleaseIdentifiers
    }
}
