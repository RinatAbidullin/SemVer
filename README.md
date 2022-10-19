# SemVer

Реализация семантического версионирования. Подробно о нем вы можете прочитать на сайте [semver.org](https://semver.org/lang/ru/)

```
    3.25.12-alpha+sha.5114f85
    - -- -- ----- -----------
    |  |  |   |        |    
Major  |  |   |        Build
   Minor  |   |
      Patch   PreRelease
```

## Установка

Добавить библиотеку можно через SPM:

```swift
.package(
    url: "https://github.com/RinatAbidullin/SemVer.git", 
    .upToNextMajor(from: "1.0.0")
)
```

## Создание версии

Создать версию можно двумя способами:

1. Передачей всех компонентов отдельно:

   ```swift
   // 1. Создаем версию "1.4.32"
   let version = try SemVer(
       major: 1,
       minor: 4,
       patch: 32
   )
   // 2. Создаем версию "1.4.32-alpha"
   let version = try SemVer(
       major: 1,
       minor: 4,
       patch: 32,
       preRelease: ["alpha"]
   )
   // 3. Создаем версию "1.4.32+exp.sha.fd54sd"
   let version = try SemVer(
       major: 1,
       minor: 4,
       patch: 32,
       build: ["exp", "sha", "fd54sd"]
   )
   // 4. Создаем версию "1.4.32-beta+exp.sha.fd54sd"
   let version = try SemVer(
       major: 1,
       minor: 4,
       patch: 32,
       preRelease: ["beta"],
       build: ["exp", "sha", "fd54sd"]
   )
   ```

2. Из строки:

   ```swift
   // 1
   let version = try SemVer(string: "1.4.32")
   // 2
   let version = try SemVer(string: "1.4.32-alpha+1032")
   // 3. Создаем версию "1.4.0"
   let version = try SemVer(string: "1.4", allowSkippingMinorOrPatch: true)
   // 4. Создаем версию "2.0.0"
   let version = try SemVer(string: "2", allowSkippingMinorOrPatch: true)
   
   // Не используйте параметр allowSkippingMinorOrPatch, если собираетесь
   // строго соответсвовать правилам semver.org
   ```

## Сравнение версий

Версии поддерживают сравнения согласно правилам, опубликованным на [semver.org](https://semver.org/lang/ru/):

```swift
// 1
let version1 = try SemVer(string: "1.2.0")
let version2 = try SemVer(string: "1.2.1")
version1 < version2 // true
// 2
let version1 = try SemVer(string: "1.2.0")
let version2 = try SemVer(string: "1.2.0-alpha")
version1 < version2 // false
// 3
let version1 = try SemVer(string: "1.2.0-alpha")
let version2 = try SemVer(string: "1.2.0-beta")
version1 < version2 // true
// 4
let version1 = try SemVer(string: "1.2.0")
let version2 = try SemVer(string: "1.2.0+exp.sha.fd54sd")
version1 == version2 // true
// 5
let version1 = try SemVer(string: "1.2.0-beta.2")
let version2 = try SemVer(string: "1.2.0-beta.11")
version1 < version2 // true
```

## Преобразование версии в строку

Преобразуйте структуру `SemVer` в строку, например, когда нужно сохранить ее в БД:

```swift
// Создаем версию
let version = try SemVer(
    major: 1,
    minor: 4,
    patch: 32,
    preRelease: ["beta"],
    build: ["exp", "sha", "fd54sd"]
)
// Преобразовываем версию в строку
let representation = version.asString // "1.4.32-beta+exp.sha.fd54sd"
```