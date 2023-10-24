//
//  SemVer+StringRepresentation.swift
//
//
//  Created by Rinat Abidullin on 24.10.2023.
//

extension SemVer {
    /// Строковое представление версии (по строгим правилам `SemVer`)
    public var asString: String {
        asString()
    }

    /// Строковое представление версии (строгие правила `SemVer` могут быть ослаблены за счет опций).
    /// - Parameter options: Опции при преобразовании версии в строковое представление.
    /// - Returns: Строковое представление версии.
    public func asString(with options: Set<OutputOption> = []) -> String {
        var version = "\(major)"

        if !isPossibleOmitMinor(with: options) {
            version.append(".\(minor)")
        }

        if !isPossibleOmitPatch(with: options) {
            version.append(".\(patch)")
        }

        if !options.contains(.omitPreRelease) && !preReleaseIdentifiers.isEmpty {
            version.append("-\(preReleaseIdentifiers.joined(separator: "."))")
        }

        if !options.contains(.omitBuild) && !buildIdentifiers.isEmpty {
            version.append("+\(buildIdentifiers.joined(separator: "."))")
        }

        return version
    }

    private func isPossibleOmitMinor(with options: Set<OutputOption>) -> Bool {
        if
            options.contains(.omitMinorAndPatchIfPossible) &&
            minor == 0 &&
            !(major == 0 || patch != 0)
        {
            return true
        }
        return false
    }

    private func isPossibleOmitPatch(with options: Set<OutputOption>) -> Bool {
        if
            !options.intersection([.omitMinorAndPatchIfPossible, .omitPatchIfPossible]).isEmpty &&
            patch == 0
        {
            return true
        }
        return false
    }
}
