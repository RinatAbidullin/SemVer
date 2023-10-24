//
//  Bundle+SemVer.swift
//
//
//  Created by Rinat Abidullin on 22.10.2022.
//

import Foundation

public extension Bundle {
    /// Версия приложения (проекта), приведенная к формату `SemVer`.
    var semVer: SemVer? {
        guard let versionNumberOfBundle = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return nil
        }
        guard let iterationOfBundle = infoDictionary?["CFBundleVersion"] as? String else {
            return try? SemVer(string: versionNumberOfBundle, options: [.allowSkippingMinorOrPatch])
        }
        return try? SemVer(
            string: "\(versionNumberOfBundle)+\(iterationOfBundle)",
            options: [.allowSkippingMinorOrPatch]
        )
    }
}
