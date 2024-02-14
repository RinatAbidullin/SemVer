//
//  SemVer+Next.swift
//
//
//  Created by Rinat Abidullin on 10.02.2024.
//

public enum IncrementalVersionComponent {
    case major
    case minor
    case patch
}

public enum IdentifiersAction {
    /// Установка новых идентификаторов
    case setNew([String])
    /// Сохранение текущих значений идентификаторов
    case keep
    /// Удаление идентификаторов
    case delete
}

extension SemVer {
    /// Получение следующей версии, соответствующей обратно несовместимому, обратно совместимому изменению или патчу.
    /// Например, мажорное повышение версии `1.3.25` даст версию `2.0.0`, минорное - `1.4.0`, а патч - `1.3.26`.
    /// - Parameters:
    ///   - versionComponent: Компонент версии, который требуется повысить.
    ///   - identifiersAction: Действия над идентификаторами `PreRelease` и `Build`.
    ///   По умолчанию идентификаторы будут удалены для следующей версии - например, мажорное повышение
    ///   версии `1.3.25-alpha+17` даст версию `2.0.0`. Можно использовать действие `.keep`, чтобы сохранить
    ///   идентификаторы - в таком случае мажорное повышение версии `1.3.25-alpha+17` даст версию `2.0.0-alpha+17`.
    /// - Returns: Следующая (инкрементированная) версия.
    public func next(
        _ versionComponent: IncrementalVersionComponent,
        with identifiersAction: (preRelease: IdentifiersAction, build: IdentifiersAction) = (.delete, .delete)
    ) throws -> Self {
        var newMajor = major
        var newMinor = minor
        var newPatch = patch

        switch versionComponent {
        case .major:
            guard major < Int.max else { throw SemVerError.versionNumberDataTypeOverflow}
            newMajor += 1
            newMinor = 0
            newPatch = 0
        case .minor:
            guard minor < Int.max else { throw SemVerError.versionNumberDataTypeOverflow}
            newMinor += 1
            newPatch = 0
        case .patch:
            guard patch < Int.max else { throw SemVerError.versionNumberDataTypeOverflow}
            newPatch += 1
        }

        var newPreReleaseIdentifiers = preReleaseIdentifiers
        switch identifiersAction.preRelease {
        case .setNew(let newIdentifiers):
            newPreReleaseIdentifiers = newIdentifiers
        case .keep:
            break
        case .delete:
            newPreReleaseIdentifiers = []
        }

        var newBuildIdentifiers = buildIdentifiers
        switch identifiersAction.build {
        case .setNew(let newIdentifiers):
            newBuildIdentifiers = newIdentifiers
        case .keep:
            break
        case .delete:
            newBuildIdentifiers = []
        }

        return try Self.init(
            major: newMajor,
            minor: newMinor,
            patch: newPatch,
            preReleaseIdentifiers: newPreReleaseIdentifiers,
            buildIdentifiers: newBuildIdentifiers
        )
    }
}
