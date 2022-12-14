//
//  SemVer+Comparable.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

extension SemVer: Comparable {
    public static func < (lhs: SemVer, rhs: SemVer) -> Bool {
        guard lhs.major == rhs.major else {
            return lhs.major < rhs.major
        }
        guard lhs.minor == rhs.minor else {
            return lhs.minor < rhs.minor
        }
        guard lhs.patch == rhs.patch else {
            return lhs.patch < rhs.patch
        }
        if !lhs.preReleaseIdentifiers.isEmpty && rhs.preReleaseIdentifiers.isEmpty {
            return true
        }
        if lhs.preReleaseIdentifiers.isEmpty && !rhs.preReleaseIdentifiers.isEmpty {
            return false
        }

        for i in 0 ..< min(lhs.preReleaseIdentifiers.count, rhs.preReleaseIdentifiers.count) {
            guard lhs.preReleaseIdentifiers[i] != rhs.preReleaseIdentifiers[i] else { continue }
            return Self.isLess(lhs.preReleaseIdentifiers[i], than: rhs.preReleaseIdentifiers[i])
        }

        return lhs.preReleaseIdentifiers.count < rhs.preReleaseIdentifiers.count
    }

    private static func isLess(_ lhsIdentifier: String, than rhsIdentifier: String) -> Bool {
        if Int(lhsIdentifier) != nil && Int(rhsIdentifier) == nil {
            return true
        }
        if Int(lhsIdentifier) == nil && Int(rhsIdentifier) != nil {
            return false
        }
        if let numericLhsIdentifier = Int(lhsIdentifier), let numericRhsIdentifier = Int(rhsIdentifier) {
            return numericLhsIdentifier < numericRhsIdentifier
        }
        return lhsIdentifier < rhsIdentifier
    }
}
