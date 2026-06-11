# ⚡ E-Bill Estimator

> A Flutter Android application for estimating monthly electricity bills using the TNB tiered block rate structure.
---

## 📋 Table of Contents

- [About](#about)
- [Features](#features)
- [Rate Structure](#rate-structure)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [License](#license)

---

## About

**E-Bill Estimator** is a mobile application developed as part of a university Mobile Technology course assignment. It allows users to estimate their monthly electricity bill by entering the billing month, units consumed (kWh), and an optional rebate percentage. Results are stored locally using SQLite and can be viewed, edited, or deleted at any time.

---

## Features

- 📅 **Month Selection** — Choose from January to December via a dropdown
- ⚡ **Unit Input** — Enter electricity usage from 1 to 1000 kWh with full input validation
- 💸 **Rebate Slider** — Apply a rebate between 0% and 5% using an interactive slider
- 🧮 **Tiered Calculation** — Automatically calculates charges based on TNB block rates
- 💾 **Local Database** — All records saved offline using SQLite (via `sqflite`)
- 📜 **Bill History** — View all saved bills in a scrollable list showing month and final cost
- 🔍 **Record Detail** — Tap any record to view full details including units, charges, rebate, and final cost
- ✏️ **Edit & Delete** — Modify or remove any saved record from the detail page
- ℹ️ **About Page** — Developer info, app instructions, and a clickable GitHub link
- 🎨 **Orange Theme** — Consistent warm orange colour scheme throughout the app
- ⚠️ **Error Handling** — Helpful validation messages and notices on all inputs

---

## Rate Structure

Electricity charges are calculated using the following TNB tiered block rates:

| Block | Units (kWh) | Rate (sen/kWh) |
|-------|-------------|----------------|
| Block 1 | 1 – 200 | 21.8 |
| Block 2 | 201 – 300 | 33.4 |
| Block 3 | 301 – 600 | 51.6 |
| Block 4 | 601 – 1000 | 54.6 |

**Final Cost Formula:**
```
Final Cost = Total Charges − (Total Charges × Rebate%)
```

**Example:**
```
150 kWh → 150 × 0.218 = RM 32.00
250 kWh → (200 × 0.218) + (50 × 0.334) = RM 60.30
467 kWh → (200 × 0.218) + (100 × 0.334) + (167 × 0.516) = RM 163.172
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥ 3.0.0)
- Android Studio or VS Code with Flutter plugin
- Android device or emulator (API 21+)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/KizheOthman/ebill-estimator.git
   cd ebill-estimator
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Build Signed APK

. Build the release APK:
   ```bash
   flutter build apk --release
   ```

   Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## Project Structure

```
lib/
├── main.dart                  # App entry point & theme configuration
├── models/
│   └── bill_record.dart       # BillRecord data model
├── database/
│   └── db_helper.dart         # SQLite database helper (CRUD operations)
├── utils/
│   └── calculator.dart        # Tiered electricity rate calculator
└── screens/
    ├── home_screen.dart        # Main calculator screen
    ├── history_screen.dart     # Bill history list view
    ├── detail_screen.dart      # Record detail, edit & delete
    └── about_screen.dart       # About page with developer info
```

---

## Usage

1. **Open the app** — the home screen displays the bill calculator
2. **Select a month** from the dropdown menu
3. **Enter the units used** (kWh) in the number field
4. **Drag the slider** to set a rebate percentage (0%–5%)
5. **Tap Calculate** to see the total charges and final cost
6. **Tap Save Record** to store the result in the local database
7. **Tap the history icon** (top right) to view all saved records
8. **Tap any record** to view full details, edit values, or delete the entry
9. **Tap the info icon** (top right) to visit the About page

---

## Technologies Used

| Technology | Purpose |
|---|---|
| [Flutter](https://flutter.dev) | Cross-platform mobile framework |
| [Dart](https://dart.dev) | Programming language |
| [sqflite](https://pub.dev/packages/sqflite) | Local SQLite database |
| [path](https://pub.dev/packages/path) | File path utilities |
| [url_launcher](https://pub.dev/packages/url_launcher) | Launch external URLs |
| [intl](https://pub.dev/packages/intl) | Internationalisation support |

---

## Assignment Details

| Item | Detail |
|---|---|
| Course | Mobile Technology |
| Assignment | Individual Assignment (20%) |
| CLO | CLO2 / LO2 |
| Platform | Android (Flutter) |
| Database | SQLite (local/offline) |

---

## License

© 2025 Kizhe Othman. All Rights Reserved.

This project was developed for academic purposes as part of a university assignment.

---

## 🔗 Links

- **GitHub Repository:https://github.com/KizheOthman/ebill-estimator

