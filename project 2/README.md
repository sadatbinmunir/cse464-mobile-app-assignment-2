# CSE 464 - Mobile Application Development
## Project 2: Multi-Step Form Wizard with Navigation & Draft Persistence

A production-grade, 4-step responsive Flutter application with strict per-step validation, live progress tracking, jump-to-step navigation, and local draft save/restore functionality.

---

### 📋 Assignment Requirements & Implementation

| Requirement | Implementation Detail |
|---|---|
| **Step 1: Personal Information** | First Name, Last Name, Gender selection (chips), Date of Birth picker (with automatic age calculation and 16+ year constraint), and Student/National ID. |
| **Step 2: Contact Details** | Email Address (RFC regex validation), Phone Number, Residential Street Address, City, Postal / Zip Code, and Country dropdown selector. |
| **Step 3: Preferences & Settings** | Primary Role selection, Preferred Communication Channel (Email, SMS, Push Notification), Theme preference, Newsletter subscription, 2FA toggle, and mandatory Data Privacy agreement. |
| **Step 4: Review & Submit** | Formatted summary cards for all prior steps. Includes **"Edit" buttons** on each section to jump back immediately to that step, plus a mandatory certification checkbox. |
| **Step Navigation with Validation** | Users cannot advance until all fields in the current step pass validation. Failing fields display inline error text and a warning banner. |
| **Progress Indicator** | Custom interactive 4-step progress header featuring connected step circles, dynamic completion percentage (25% → 100%), and direct tapping on visited steps. |
| **Save Draft Functionality** | `DraftService` enables saving unfinished applications at any point with real-time timestamps. Displays an alert banner on app startup if a saved draft is detected with a one-click "Restore Draft" option. |
| **Back / Next Buttons** | Dynamic bottom navigation bar with contextual Back, Save Draft, and Next/Submit buttons with asynchronous progress indication. |

---

### 📁 Project Architecture

```text
project 2/
├── lib/
│   ├── main.dart                          # App entry point & Material 3 theming (Emerald/Teal)
│   ├── models/
│   │   └── wizard_form_data.dart          # Comprehensive multi-step form data model (JSON serializable)
│   ├── services/
│   │   └── draft_service.dart             # Local draft persistence, recovery, and timestamping
│   ├── utils/
│   │   └── form_validators.dart           # Custom regex & logical validators for all steps
│   ├── widgets/
│   │   ├── custom_text_input.dart         # Reusable styled text field with error decorations
│   │   ├── step_progress_bar.dart         # 4-step visual indicator with percentage & tapping
│   │   └── submission_success_dialog.dart # Celebration modal with application summary
│   └── screens/
│       ├── wizard_screen.dart             # Main wizard coordinator (step state, draft banner, navigation)
│       └── steps/
│           ├── step1_personal.dart        # Personal identity inputs
│           ├── step2_contact.dart         # Contact & address inputs
│           ├── step3_preferences.dart    # Role, preferences, notification channels & privacy
│           └── step4_review.dart          # Final review cards with quick-edit shortcuts
└── test/
    ├── form_validators_test.dart          # Unit tests covering all input validators
    └── widget_test.dart                   # Smoke test for multi-step wizard rendering
```

---

### 🚀 Running the Project

1. Navigate to the project directory:
   ```bash
   cd "project 2"
   ```

2. Run the application:
   ```bash
   flutter run
   ```

3. Run automated tests:
   ```bash
   flutter test
   ```

4. Run code analysis:
   ```bash
   flutter analyze
   ```
