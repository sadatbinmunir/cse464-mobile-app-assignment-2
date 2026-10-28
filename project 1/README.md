# CSE 464 - Mobile Application Development
## Project 1: Comprehensive User Registration Form with Validation

A feature-complete, modern Flutter user registration application built with Material 3 design and comprehensive input validation.

---

### 📋 Assignment Requirements & Implementation

| Requirement | Implementation Detail |
|---|---|
| **Personal Info Fields** | Full Name (letters & space check, 2+ words), Email (RFC pattern), Phone (local & international), Age (13–120), NID (10, 13, or 17 digit validation). |
| **Password & Strength Meter** | Real-time visual progress bar, color-coded level (Weak → Strong), and live checklist: 8+ chars, uppercase, lowercase, digit, special character. Confirm password match validation. |
| **Country Dropdown with Search** | Interactive modal sheet with instant real-time search filtering across country names, ISO codes, dial codes, and flag emojis. |
| **Gender Radio Buttons** | Interactive radio button selectors for Male, Female, and Other with error states. |
| **Interests Checkboxes** | Multi-select checkboxes covering tech domains with convenient "Select All" and "Clear" buttons. |
| **Date Picker for Birth Date** | Native Material date picker that automatically calculates and synchronizes the Age field. |
| **Custom `Validators` Class** | Standalone `Validators` utility class in `lib/utils/validators.dart` with robust regex and unit tests. |
| **Beautiful UI** | Material 3 theme, rounded input containers, responsive layout, clear error states, and a submission summary dialog. |

---

### 📁 Project Architecture

```text
project 1/
├── lib/
│   ├── main.dart                          # App entry point & Material 3 theming
│   ├── models/
│   │   ├── country.dart                   # Country model & predefined dataset
│   │   └── user_registration.dart         # Registered user data model
│   ├── utils/
│   │   └── validators.dart                # Custom Validators & PasswordStrength engine
│   ├── widgets/
│   │   ├── birth_date_picker_field.dart   # Interactive date of birth picker
│   │   ├── country_picker_field.dart      # Searchable country modal sheet
│   │   ├── custom_text_field.dart         # Styled text input with validation & error states
│   │   ├── gender_selector.dart           # Custom styled radio button group
│   │   ├── interest_selector.dart         # Multi-select checkboxes with Select All/Clear
│   │   ├── password_field.dart            # Password input with live strength indicator
│   │   └── registration_summary_dialog.dart # Submission success modal dialog
│   └── screens/
│       └── registration_screen.dart       # Main comprehensive registration form
└── test/
    ├── validators_test.dart               # Complete unit test suite for all Validators
    └── widget_test.dart                   # Smoke test for screen rendering
```

---

### 🚀 Running the Project

1. Navigate to the project directory:
   ```bash
   cd "project 1"
   ```

2. Run the application:
   ```bash
   flutter run
   ```

3. Run the automated test suite:
   ```bash
   flutter test
   ```

4. Run code analysis:
   ```bash
   flutter analyze
   ```
