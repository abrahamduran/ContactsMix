
# ContactsMix — MVVM (ObjC + SwiftUI) Technical Exercise

This repo implements a small contacts app mixing **Objective‑C** (list screen) and **SwiftUI** (create screen) with a clean **MVVM** separation and a lightweight persistence layer. It follows the step‑by‑step plan I proposed.

## Project Overview

- **List (Objective‑C + UIKit)**: `ContactListViewController` shows contacts, supports search and swipe‑to‑delete.
- **Create (SwiftUI)**: `AddContactView` lets you enter first/last name, phone, and load a random photo.
- **MVVM**: `ContactListViewModel` (Objective‑C‑friendly) and `AddContactViewModel` (SwiftUI) orchestrate logic.
- **Model**: `Contact` is `NSObject + NSSecureCoding` so it bridges to ObjC and persists safely.
- **Persistence**: `UserDefaultsContactStore` via `NSKeyedArchiver/Unarchiver` (swap‑in Core Data later).
- **Interop**: `AddContactFactory` returns a `UIHostingController` to present SwiftUI from ObjC.
- **Random Photo API**: Uses `https://picsum.photos/seed/<uuid>/400` (no API key required).

> The list is intentionally in Objective‑C to prove bridging and mixed‑language MVVM. The create form uses SwiftUI for a modern, concise UI.

---

## Folder Structure

```
ContactsMix/
 ├─ App/
 │   ├─ AppDelegate.m, SceneDelegate.m
 ├─ Model/
 │   ├─ Contact.swift
 │   ├─ ContactStore.swift
 ├─ ViewModel/
 │   ├─ ContactListViewModel.swift
 │   ├─ AddContactViewModel.swift
 ├─ View/
 │   ├─ ContactListViewController.h/m (ObjC)
 │   ├─ AddContactView.swift (SwiftUI)
 │   ├─ AddContactFactory.swift
 ├─ Resources/
 │   ├─ Info.plist
 └─ ContactsMix-Bridging-Header.h
```

---

## Build & Run

1. **Xcode New Project** → iOS App → **Storyboard** + **Objective‑C**.
2. Add any Swift file when prompted; let Xcode create the **Bridging Header**.
3. Add the Swift and ObjC files from this exercise into their folders.
4. In `SceneDelegate.m`, set the root to `UINavigationController(root: ContactListViewController())`.
5. Run on iOS 16+ simulator or device.

> No additional entitlements or API keys are needed. Photos are downloaded via HTTPS from Picsum.

---

## MVVM Responsibilities

- **Model**: `Contact`
  - `identifier`, `firstName`, `lastName`, `phone`, `imageURL`
  - `NSSecureCoding` to persist and interop with ObjC.
- **ViewModels**
  - `ContactListViewModel` (Swift, `@objcMembers`): loading, filtering, add/delete, exposing ObjC‑friendly methods (`numberOfItems()`, `item(at:)`, etc.).
  - `AddContactViewModel` (Swift, `ObservableObject`): form state, validation (`canSave`), random image loader.
- **Views**
  - ObjC `UITableViewController` style controller as the list (UIKit).
  - SwiftUI form for creation, presented via a factory as `UIHostingController`.

---

## Bridging Notes (ObjC ↔ Swift)

- Mark Swift classes used by ObjC with `@objcMembers` and inherit from `NSObject`.
- Import `"YourTargetName-Swift.h"` inside ObjC files to access Swift types.
- Keep ObjC facing APIs ergonomic (e.g., `numberOfItems()` instead of `count` properties).

---

## Search & Delete

- `UISearchController` filters by first name, last name, phone (case‑insensitive).
- Swipe‑to‑delete supported; optional "Edit" mode toggled by the right bar button.

---

## Persistence

- `UserDefaultsContactStore` serializes the array of `Contact` with `NSKeyedArchiver` (`requiresSecureCoding=true`).
- Swap with a `CoreDataContactStore` later without changing Views or ViewModels.

---

## Random Photo API

- Press **“Cargar foto aleatoria”** to assign a unique URL from Picsum (`/seed/<uuid>/400`).
- Loaded with `AsyncImage` in SwiftUI and a simple `URLSession` fetch in the ObjC list cell.

---

## Testing Ideas

- **ViewModel**: Unit test `ContactListViewModel.applyFilter()` with in‑memory fake store.
- **Persistence**: Verify encode/decode `Contact` with `NSSecureCoding` roundtrips.
- **Interop**: Smoke test that `AddContactFactory.make(...)` returns a live VC and invokes callbacks.

---

## Future Improvements

- Image caching (e.g., `URLCache` or a tiny in‑memory cache in the list cells).
- Core Data store with migrations and background contexts.
- Input validation/formatting for phone numbers by locale.
- UI tests for add/search/delete flows.
- Pull‑to‑refresh sample data loader (optional).

---