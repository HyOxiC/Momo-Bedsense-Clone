# BedSense (Unofficial) – Flutter Prototype

This is a UI‑first prototype exploring how a BedSense style app could feel in Flutter. It isn’t affiliated with Momo and it doesn’t use real data. I built it to think through caregiver workflows and show the kind of product I like to work on.

## Why I built it
I’ve spent the last few years building hospital apps (EMRs for doctors, nurses, patients). Caregivers carry a lot, and good tools help them focus on people, not screens. I came across Momo’s work and wanted to sketch a calm, clear UI that surfaces what matters quickly status, alerts, and context.

## Screens at a glance
- Overview: quick stats, trends, and recent activity.
- Alerts: priority‑based list with simple filters.
- Resident detail: snapshot of status with room and time context.
- Support: quick links, resources, and FAQ (static).

## How it’s put together
- State: Riverpod 2 (providers kept simple for this prototype).
- Navigation: GoRouter 16 with a `StatefulShellRoute` bottom navigation.
- Design system: Material 3 with small `ThemeExtension`s for spacing, motion, type, and chart tokens.
- Charts: lightweight custom painter donut and line charts to avoid heavy deps.
- Responsiveness: `responsive_framework` breakpoints for phone/tablet/desktop.
- Animations: fade‑through for tabs, shared‑axis for details, and small list transitions.

## Project structure
```
lib/
├─ src/
│  ├─ app/            # router, theme, tokens
│  ├─ core/           # constants, loading provider
│  ├─ features/       # overview, alerts, support, resident
│  ├─ shell/          # bottom nav shell
│  └─ widgets/        # cards, charts, glass, etc.
└─ main.dart
```

## Assumptions I made
- The primary jobs are: spot issues quickly, drill into a resident, and act.
- A calm look and small motion helps during long shifts and low‑light environments.
- Three tabs are enough for a first pass: Overview, Alerts, Support.
- Fake data is fine as long as the interaction model feels honest.

## What’s missing (on purpose)
- Real data layer (API, caching, persistence)
- Auth and roles
- Telemetry/analytics and error reporting
- Accessibility pass and localization (strings are English‑only)

## If I had another week
- Add a repository interface + mock service to show data flow.
- Wire a couple of real network calls and basic caching.
- Add golden tests for the main widgets and chart snapshots.
- Add a11y polish: semantics, large text, and contrast checks.
- Record a short walkthrough and include screenshots/gifs.

## Run it
1. flutter pub get
2. flutter run
