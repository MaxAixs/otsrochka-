# Отсрочка+

Навчальний iOS-застосунок (Swift / SwiftUI) — спрощений аналог Резерв+:
електронний військово-обліковий документ офлайн, без бекенда.

> **Дисклеймер:** це демо/навчальний проєкт. Не пов'язаний з Міноборони України,
> не створює юридично чинних документів. Не вводьте реальні персональні дані третіх осіб.

## 🌐 Живе демо (PWA-прототип)

Після ввімкнення Pages прототип доступний за адресою:

**https://maxaixs.github.io/otsrochka-/**

Прототип (`prototype/`) повторює логіку iOS-застосунку:
Старт «Почати» → Реєстрація (прізвище, ім'я, по батькові, дата народження)
→ Документ-картка → тап по центру відкриває QR-код → стрічка
«Документи оновлено: <сьогоднішня дата>».

## ✅ Як увімкнути сторінку в GitHub (1 раз, ~1 хв)

1. Відкрийте репозиторій на GitHub: `MaxAixs/otsrochka-`.
2. Зайдіть у **Settings → Pages** (зліва в меню).
3. У блоці **Build and deployment** поставте:
   - **Source: GitHub Actions** (а НЕ «Deploy from a branch»).
4. Зайдіть у вкладку **Actions → PWA Pages → Run workflow → Run workflow**
   (або просто запуште будь-яку зміну в `prototype/` — деплой стартує сам).
5. Дочекайтесь зеленої галочки ✅ — сторінка буде на URL вище.

Як це працює технічно:

- Воркфлоу [`.github/workflows/pwa.yml`](.github/workflows/pwa.yml) пакує папку
  `prototype/` як артефакт і деплоїть через `actions/deploy-pages@v4`.
- Файл [`prototype/.nojekyll`](prototype/.nojekyll) вимикає Jekyll, щоб Pages
  віддавав файли як є (потрібно для файлів на кшталт `manifest.webmanifest`).
- Усі шляхи в прототипі відносні (`./...`), тому він однаково працює
  і локально, і на project pages за префіксом `/otsrochka-/`.

## ▶️ Локальний запуск прототипу

```bash
cd prototype
python3 server.py        # http://127.0.0.1:8080/
```

## 📱 iOS-застосунок

```bash
open OtsrochkaPlus.xcodeproj   # згенерувати через xcodegen generate, якщо проєкту нема

# лінт + формат
swiftlint lint
swiftformat --lint .
```

- Мінімум: **iOS 17**, Xcode 16+.
- Архітектура: MVVM-C + Clean Layers (див. `AGENTS.md`).
- Дані: локальний SQLite через GRDB, міграції через `DatabaseMigrator`.
- QR: CoreImage `CIQRCodeGenerator`, без сторонніх залежностей.

```
OtsrochkaPlus/        # SwiftUI Views, ViewModels, Coordinators, Domain, Data
prototype/            # PWA-прототип для GitHub Pages (index/registration/document)
docs/images/          # локальні скриншоти (не трекаються в git, див. .gitignore)
```
