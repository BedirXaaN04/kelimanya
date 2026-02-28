# AGENTS.md

## Must-follow constraints
- **Platform-Specific Execution:** Guard mobile-only plugins (e.g., `google_mobile_ads` via `AdService`) with `if (!kIsWeb)`. The app builds for both Web and Android; failing to guard native plugins will crash the web build.
- **State Management Contract:** The Flutter app strictly uses `Provider` (`ChangeNotifier` / `MultiProvider`). Do not introduce BLoC, Riverpod, or GetX. Centralize game state in `GameProvider`.
- **Admin Panel Stack:** The `admin-panel` is a **React + Vite** application. It is NOT a Next.js app. Run with `npm run dev`.

## Validation before finishing
- **Zero-Warning Policy:** GitHub Actions (`flutter_ci.yml`) enforce `flutter analyze` on `main`. You MUST run `flutter analyze` and resolve ALL warnings before concluding your task.
- **Android Native File Attrition:** The CI pipeline deletes and recreates the `android/` directory on every build, ONLY preserving `app/build.gradle`, `build.gradle`, `google-services.json`, and `AndroidManifest.xml`. Any native Android modifications made outside of these explicitly preserved files will be lost in CI.

## Repo-specific conventions
- **Brutalist UI:** The app core design system relies on `BrutalistTheme.theme`. Do not implement standard / default Material design widgets without adapting them to the established brutalist visual contract.
- **Backend Architecture:** Direct Firebase access from the client is for standard CRUD. Any operation requiring elevated privileges or cross-user side effects must be implemented in the `functions/` directory (Firebase Cloud Functions).
