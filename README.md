# CSE 464 - Mobile Application Development
## Assignment 2: Flutter Form Validation & Multi-Step Wizard Applications

This repository contains the complete implementation for **Assignment 2** of CSE 464 (Mobile Application Development), consisting of two standalone Flutter applications.

---

### 📂 Repository Structure

- **[`project 1/`](./project%201)**: **Comprehensive User Registration Form with Validation**
  - Modern Material 3 design and responsive UI.
  - Custom `Validators` class for robust validation (RFC email, 10/13/17-digit NID, 13–120 age bounds, phone numbers, full name).
  - Dynamic password strength meter with real-time checklist and progress indicator.
  - Interactive searchable modal bottom sheet for country selection.
  - Custom gender selector and multi-select interests with "Select All" / "Clear" options.
  - Date of birth picker synchronized automatically with the age field.
  - Unit tests covering all validation rules and screen smoke tests.

- **[`project 2/`](./project%202)**: **Multi-Step Form Wizard Application**
  - 4-step wizard navigation (Personal Info, Contact & Account, Preferences & Interests, Review & Submit).
  - Visual animated step progress indicator with custom navigation controls (Next, Back, Submit).
  - Draft autosave & restore engine using `SharedPreferences` (draft alert banner on startup).
  - Per-step form validation preventing forward navigation until required fields are valid.
  - Comprehensive review screen displaying formatted data summary before final submission.
  - Unit tests for step validation logic and widget tests.

---

### 🚀 Running the Projects

Each project can be run independently using Flutter:

#### Running Project 1
```bash
cd "project 1"
flutter pub get
flutter run
```

To run unit tests:
```bash
flutter test
```

#### Running Project 2
```bash
cd "project 2"
flutter pub get
flutter run
```

To run unit tests:
```bash
flutter test
```

---

### 👥 Author
- **Course**: CSE 464 - Mobile Application Development
