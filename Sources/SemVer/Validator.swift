//
//  Validator.swift
//
//
//  Created by Rinat Abidullin on 19.10.2022.
//

struct Validator {
    static let latinAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let digits = "0123456789"

    static let identifierAllowedChars = Set(latinAlphabet + digits + "-")
    static let stringOfIdentifiersAllowedChars = identifierAllowedChars.union(Set("."))

    static let semVerAllowedChars = stringOfIdentifiersAllowedChars.union(Set("+"))

    static func validate(semVer: String) throws {
        guard Self.semVerAllowedChars.isSuperset(of: Set(semVer)) else {
            throw SemVerError.semVerContainsIllegalCharacters
        }
    }

    static func validate(identifiers: [String]) throws {
        guard !identifiers.isEmpty else {
            return
        }
        guard identifiers.allSatisfy({ !$0.isEmpty }) else {
            throw SemVerError.identifierMustNotBeEmpty
        }
        for identifier in identifiers {
            guard Self.identifierAllowedChars.isSuperset(of: Set(identifier)) else {
                throw SemVerError.identifierContainsIllegalCharacters
            }
            if Int(identifier) != nil {
                try validate(version: identifier)
            }
        }
    }

    @discardableResult
    static func validate(version: String) throws -> Int {
        guard !(version.hasPrefix("0") && version.count > 1) else {
            throw SemVerError.versionMustNotContainLeadingZeroes
        }
        guard let number = Int(version) else { throw SemVerError.versionIsNotRepresentedByNumber }
        guard number >= 0 else { throw SemVerError.versionCannotBeNegative }
        return number
    }
}
