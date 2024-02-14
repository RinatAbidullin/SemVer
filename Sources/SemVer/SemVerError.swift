//
//  SemVerError.swift
//
//
//  Created by Rinat Abidullin on 18.10.2022.
//

public enum SemVerError: Error {
    case invalidFormat
    case identifierMustNotBeEmpty
    case identifierContainsIllegalCharacters
    case semVerContainsIllegalCharacters
    case versionCannotBeNegative
    case versionIsNotRepresentedByNumber
    case versionMustNotContainLeadingZeroes
    case versionNumberDataTypeOverflow
}
