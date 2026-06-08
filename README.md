# Pendar

Pendar is a cross-platform mobile mental health application designed for university students. It integrates an XGBoost machine learning model to predict burnout levels in real time based on users' psychological metrics. The app aims to provide timely assessment and actionable support to help students manage stress and improve mental wellbeing.

## Key Features
- Mind Check: Real-time analysis of burnout risk using an XGBoost model trained on psychological metrics.
- Breathing Intervention: Guided 4-7-8 breathing exercise to help users reduce acute stress.
- Digital Journal: Secure journaling with auto-save to support reflection and track mood over time.
- Task & Schedule Management: Simple task scheduling and reminders to support recovery and time management.

These features are designed to provide a holistic approach to student mental health, combining predictive analytics with practical interventions and ongoing self-monitoring.

## Project Overview
Pendar is implemented primarily in Dart (Flutter) with some native and build-time components in C++, C, Swift, and CMake configuration. The codebase contains platform-specific integrations and native modules where required.

This document is intentionally concise — if you provide the app's primary purpose, additional features, screenshots, or example workflows, I can expand this README with user-facing descriptions and visuals.

## Tech Stack
- Dart — Primary language for application logic and UI (Flutter).
- Flutter — Cross-platform UI toolkit.
- C++ — Native modules / performance-sensitive code.
- C — Low-level native components or dependencies.
- Swift — iOS platform code and native integration.
- CMake — Native build configuration for C/C++ components.
- HTML — Possibly used for web assets or embedded web views.

Other common files you may find in this repo:
- `pubspec.yaml` — Dart/Flutter dependency and project configuration.
- Platform-specific folders (`android`, `ios`, etc.) containing native integrations.
- `assets/` — Images, fonts, and static resources used by the app.

## Folder Structure (Typical)
- / (root)
  - README.md — This file.
  - pubspec.yaml — Dart/Flutter project configuration and dependencies.
  - pubspec.lock — Locked dependency versions (generated).
  - analysis_options.yaml — Dart analyzer configuration (optional).
  - /lib
    - main.dart — App entry point.
    - /src or /app — Application modules, widgets, services, and state management.
    - /models — Data model classes.
    - /screens or /pages — UI screens.
    - /widgets — Reusable widgets.
    - /utils or /helpers — Utility functions.
  - /android — Android platform code and Gradle build files.
  - /ios — iOS platform code, Swift/Objective-C files and Xcode project.
  - /macos, /windows, /linux — Desktop platform folders if present.
  - /web — Web-specific assets and entrypoints (if the app targets web).
  - /cpp or /native — C++ source files for native modules, plugins, or libraries.
  - /cmake — CMake toolchain and configuration files for native builds.
  - /assets — Images, fonts, icons, and other static resources.
  - /test — Unit and widget tests for Dart code.
  - /examples or /example — Example apps or usage demonstrations (optional).
  - /scripts — Build, CI, or helper scripts (optional).

Notes:
- Native integrations (C/C++, Swift) are typically found in platform-specific directories or a separate `native/` or `cpp/` folder. CMake files facilitate building native modules that the Dart/Flutter app may use.
- If the project contains plugin-style code, expect a `src/` or `include/` structure inside native folders and bridging headers on iOS.

## How to run (quick start)
A minimal set of commands for a Flutter project (adjust if this repo is organized differently):

1. Install the Flutter SDK and set up platform dependencies (Android Studio / Xcode).
2. From the repo root:
   - `flutter pub get`
   - `flutter run`

For native modules, ensure CMake and required native toolchains are installed and configured according to platform documentation.
