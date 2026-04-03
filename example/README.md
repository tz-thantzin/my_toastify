# Toastify example app

This example app is organized as a small catalog of copy-paste friendly toast scenarios.

## File structure

- `lib/main.dart` – demo shell and sectioned UI
- `lib/examples/basic_examples.dart` – baseline snackbar and banner patterns
- `lib/examples/layout_examples.dart` – width/alignment examples including bottom-right half-width web usage
- `lib/examples/customization_examples.dart` – leading widgets, actions, border/shadow and persistent toasts
- `lib/examples/demo_catalog.dart` – shared demo models used by the catalog UI

## Why this layout

The example code is split by concern so package users can quickly lift only the scenario they need instead of scanning one very long `main.dart` file.
