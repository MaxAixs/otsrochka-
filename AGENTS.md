# AGENTS.md — Otsrochka+

## Project Overview

**Otsrochka+** is an educational iOS application written in **Swift / SwiftUI** that recreates the core experience of **Rezerv+** (Резерв+) — the electronic military registration document app by the Ministry of Defense of Ukraine.

The app works fully **offline**: there is no backend. All data is stored locally in **SQLite**.

> **Disclaimer:** This is a demo/educational project. It is NOT affiliated with the Ministry of Defense of Ukraine, does NOT produce legally valid documents, and must NOT be used with real personal data of third parties.

### Core Features (MVP)

1. **Start screen** — a single "Почати" (Start) button.
2. **Registration form** — the user enters:
   - First name (Ім'я)
   - Last name (Прізвище)
   - Patronymic (По батькові)
   - Date of birth (Дата народження)
3. **Document screen** — an electronic document card (analog of еВОД):
   - Displays full name (ПІБ) and date of birth.
   - **Tap on the center of the card → a QR code appears** (generated locally with CoreImage `CIQRCodeGenerator` from the stored person data).
   - **A ribbon/banner** showing: **"Документи оновлено: <today's date>"** — always rendered dynamically from `Date.now` with the current date.

### Localization

- **UI language: Ukrainian.**
- **Code, comments, documentation: English.**

---

## Tech Stack

| Layer      | Choice                                        |
|------------|-----------------------------------------------|
| UI         | SwiftUI (iOS 17+), Swift 6 strict concurrency |
| Navigation | Coordinator pattern                           |
| Database   | SQLite via **GRDB** (GRDB.swift)              |
| QR code    | CoreImage `CIQRCodeGenerator` (no 3rd party)  |
| DI         | Protocol-based, constructor injection         |
| Lint/Format| SwiftLint + SwiftFormat (Airbnb configs)      |
| Tests      | XCTest                                        |

---

## Architecture: MVVM-C + Clean Layers

Just as Uber maintains a canonical [Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md) for production-grade Go, this project follows the most respected Swift community standards (see **Coding Standards** below) and a strict layered architecture.

### Layers

```
┌─────────────────────────────────────────────┐
│ Presentation                                │
│  SwiftUI Views · ViewModels (@Observable)   │
│  Coordinators (navigation flow)             │
├─────────────────────────────────────────────┤
│ Domain                                      │
│  Entities (Person, Document) · UseCases     │
│  Repository protocols (interfaces)          │
├─────────────────────────────────────────────┤
│ Data                                        │
│  GRDB Repositories · Migrations · DTOs      │
└─────────────────────────────────────────────┘
```

Rules:

- **Presentation** depends only on **Domain** (never on Data directly).
- **Domain** contains pure Swift: no SwiftUI, no GRDB imports.
- **Data** implements Domain repository protocols using GRDB.
- **ViewModels** use Swift 6 `@Observable` macro; state mutations on `@MainActor`.
- **Async everywhere:** `async/await`, no completion handlers, no Combine for new code.
- **Coordinators** own navigation (`NavigationStack` paths); Views never navigate directly.
- **Dependency injection** via protocols through initializers; a single `AppContainer` composes the object graph at launch.

### Xcode Project Structure

```
OtsrochkaPlus/
├── App/
│   ├── OtsrochkaPlusApp.swift
│   └── AppContainer.swift            # DI composition root
├── Presentation/
│   ├── Start/
│   │   ├── StartView.swift           # "Почати" button
│   │   └── StartViewModel.swift
│   ├── Registration/
│   │   ├── RegistrationView.swift    # name / surname / patronymic / birth date
│   │   └── RegistrationViewModel.swift
│   ├── Document/
│   │   ├── DocumentView.swift        # document card
│   │   ├── DocumentViewModel.swift
│   │   ├── QRCodeView.swift          # shown on center tap
│   │   └── UpdatedRibbonView.swift   # "Документи оновлено: <today>"
│   └── Coordinators/
│       └── AppCoordinator.swift
├── Domain/
│   ├── Entities/
│   │   └── Person.swift
│   ├── UseCases/
│   │   ├── SavePersonUseCase.swift
│   │   └── FetchPersonUseCase.swift
│   └── Repositories/
│       └── PersonRepository.swift    # protocol only
├── Data/
│   ├── Database/
│   │   ├── DatabaseManager.swift     # GRDB DatabaseQueue
│   │   └── Migrations.swift
│   └── Repositories/
│       └── GRDBPersonRepository.swift
└── Resources/
    ├── Localizable.xcstrings         # uk
    └── Assets.xcassets
```

---

## Coding Standards

This project treats the following guides the same way Go teams treat the Uber Go Style Guide — as **mandatory**, enforced by tooling and code review:

1. **[Airbnb Swift Style Guide](https://github.com/airbnb/swift)** — the primary standard (100+ rules: formatting, naming, patterns, SwiftUI, testing).
2. **[Swift.org API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)** — official Apple/Swift naming and API design rules.
3. **[Kodeco Swift Style Guide](https://github.com/kodecocodes/swift-style-guide)** — supplementary reference.

### Tooling (must pass before commit)

- **SwiftLint** with Airbnb ruleset — zero warnings.
- **SwiftFormat** with Airbnb config — run on save / pre-commit.

### Key Rules (summary)

- No force unwraps (`!`) and no `try!` outside tests.
- Prefer `guard` for early exits; avoid pyramid of doom.
- Types: `UpperCamelCase`; variables/functions: `lowerCamelCase`; Ukrainian text lives only in `Localizable.xcstrings`, never hardcoded in Views.
- Views stay small (< 150 lines); extract subviews otherwise.
- ViewModels never import SwiftUI (except `@Observable`/framework basics); they expose state + intents only.
- Every ViewModel and UseCase is protocol-testable; repositories are mocked in tests.
- `self.` only when required by the compiler.
- No singletons except the DI container; no global mutable state.

---

## Data Layer (SQLite + GRDB)

- Single local database file: `otsrochka.sqlite` in Application Support.
- **Migrations via GRDB `DatabaseMigrator`** — never ad-hoc `CREATE TABLE`.
- Initial schema:

```sql
CREATE TABLE person (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    firstName     TEXT NOT NULL,
    lastName      TEXT NOT NULL,
    patronymic    TEXT NOT NULL,
    dateOfBirth   TEXT NOT NULL,        -- ISO-8601: yyyy-MM-dd
    createdAt     TEXT NOT NULL,
    updatedAt     TEXT NOT NULL
);
```

- QR payload: JSON with the person's public fields (no secrets, no real IDs — demo data only).
- All DB access goes through `PersonRepository`; Views never touch GRDB.

---

## Assets & Documentation Images

- **`docs/images/`** — screenshots, mockups, and diagrams used for visualization and referenced from documentation (e.g., app flow, document card states, QR overlay).
- Reference them in docs with relative paths, e.g. `![Document screen](docs/images/document-screen.png)`.
- In-app graphics live in `Resources/Assets.xcassets` — do not confuse the two.

---

## Testing

- Framework: **XCTest** (unit tests; UI tests optional).
- Cover: ViewModels (state transitions), UseCases, GRDB repositories (in-memory `DatabaseQueue`).
- QR payload encoding/decoding must have round-trip tests.
- Target: ≥ 80% coverage on Domain and Data layers.

---

## Build & Run

```bash
# open in Xcode
open OtsrochkaPlus.xcodeproj

# lint + format check
swiftlint lint
swiftformat --lint .
```

Minimum deployment target: **iOS 17**. Xcode 16+.
