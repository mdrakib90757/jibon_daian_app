# Jibon Daian 🩸
> **Save a Life, Give Blood** — Blood Donation App

A Flutter application built with **BLoC state management**, feature-first architecture, and clean separation of concerns.

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # 🎨 All color values
│   │   ├── app_strings.dart           # 📝 All text / string constants
│   │   ├── app_dimens.dart            # 📐 Spacing, sizing, radii
│   │   ├── app_text_styles.dart       # 🖋️  Typography styles
│   │   ├── app_routes.dart            # 🗺️  Named route constants
│   │   └── constants.dart             # Barrel export
│   │
│   ├── theme/
│   │   └── app_theme.dart             # MaterialApp theme config
│   │
│   └── utils/
│       └── app_router.dart            # Route generation + BLoC injection
│
├── shared/
│   └── widgets/
│       ├── app_primary_button.dart    # 🔘 Reusable full-width button
│       ├── app_dot_indicator.dart     # ⚫ Animated page dots
│       └── widgets.dart              # Barrel export
│
└── features/
    ├── splash/
    │   ├── bloc/
    │   │   ├── splash_bloc.dart       # Splash BLoC
    │   │   ├── splash_event.dart      # SplashStarted, ProgressUpdated, Completed
    │   │   └── splash_state.dart      # SplashInitial, SplashLoading, NavigateToOnboarding
    │   ├── widgets/
    │   │   ├── splash_logo.dart       # 🩸 Animated concentric logo
    │   │   ├── splash_progress_bar.dart  # Progress bar with % label
    │   │   └── widgets.dart           # Barrel export
    │   └── screens/
    │       └── splash_screen.dart
    │
    ├── onboarding/
    │   ├── bloc/
    │   │   ├── onboarding_bloc.dart   # Onboarding BLoC
    │   │   ├── onboarding_event.dart  # NextPage, PreviousPage, Skip, PageChanged, GetStarted
    │   │   └── onboarding_state.dart  # Initial, PageState, Complete
    │   ├── models/
    │   │   └── onboarding_page_model.dart  # OnboardingPage data model
    │   ├── widgets/
    │   │   ├── onboarding_slide_card.dart  # Image + title + description card
    │   │   ├── onboarding_nav_bar.dart     # Top nav bar (back + title + skip)
    │   │   └── widgets.dart               # Barrel export
    │   └── screens/
    │       └── onboarding_screen.dart
    │
    └── home/
        └── screens/
            └── home_screen.dart       # Placeholder — replace with your home feature
```

---

## 🏗️ Architecture

| Layer | Responsibility |
|---|---|
| `core/constants` | Global design tokens: colors, strings, dims, text styles |
| `core/theme` | MaterialApp theme wiring |
| `core/utils` | Router with BLoC provider injection |
| `shared/widgets` | Reusable widgets used across multiple features |
| `features/*/bloc` | BLoC: events, states, business logic |
| `features/*/models` | Data models for the feature |
| `features/*/widgets` | Feature-specific UI widgets |
| `features/*/screens` | Full screen composing widgets + BLoC consumers |

---

## 🎨 Design Tokens

### Colors (`app_colors.dart`)
| Token | Hex | Usage |
|---|---|---|
| `primary` | `#D94040` | Buttons, icons, progress, active dots |
| `primaryLight` | `#E87070` | Disabled state |
| `background` | `#F5F2EF` | Splash background |
| `backgroundWhite` | `#F8F8F8` | Onboarding background |
| `textPrimary` | `#1A1F36` | Headings |
| `textSecondary` | `#6B7280` | Descriptions, captions |
| `ripple1/2/3` | Various pinks | Splash logo concentric rings |

### Text Styles (`app_text_styles.dart`)
- `appName` — Brand name, 36px, ExtraBold
- `appTagline` — Uppercase tagline, 13px, letter-spaced
- `onboardingTitle` — Slide titles, 26px, ExtraBold
- `onboardingDescription` — Slide body, 15px, Regular
- `buttonLabel` — Button text, 16px, Bold
- `progressLabel` / `progressPercent` — Progress bar labels

---

## 🧱 BLoC State Machines

### SplashBloc
```
SplashInitial
  └─ SplashStarted ──► SplashLoading(0.0 → 1.0)
                              └─ SplashCompleted ──► SplashNavigateToOnboarding
```

### OnboardingBloc
```
OnboardingInitial
  └─ init ──► OnboardingPageState(page: 0)
                 ├─ NextPage ──► OnboardingPageState(page: n+1)
                 ├─ PreviousPage ──► OnboardingPageState(page: n-1)
                 ├─ PageChanged ──► OnboardingPageState(page: index)
                 ├─ Skipped ──► OnboardingComplete
                 └─ GetStarted (last page) ──► OnboardingComplete
```

---

## 📦 Dependencies

```yaml
flutter_bloc: ^8.1.3    # BLoC state management
equatable: ^2.0.5       # Value equality for states/events
google_fonts: ^6.1.0    # Nunito font family
```

---

## 🖼️ Adding Real Images

Replace the placeholder illustrations in `OnboardingSlideCard`:

1. Add images to `assets/images/`:
    - `onboarding_1.png` (Find Donors — blood drop network illustration)
    - `onboarding_2.png` (Be a Hero — donation illustration)
    - `onboarding_3.png` (Save Lives Together — community photo)

2. Register in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
```

3. In `onboarding_slide_card.dart`, replace `_OnboardingIllustration` with:
```dart
Image.asset(
  page.imagePath,
  fit: BoxFit.cover,
  width: double.infinity,
)
```

---

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```
















<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 50 PM (1)" src="https://github.com/user-attachments/assets/b008069f-9f5a-428a-9cff-f90e796f204e" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 50 PM (2)" src="https://github.com/user-attachments/assets/d69ae9bc-9d41-4c23-a067-a8493699dc39" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 51 PM (1)" src="https://github.com/user-attachments/assets/b89521b5-c7c3-453a-8bcc-3ee7693e92bc" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 50 PM" src="https://github.com/user-attachments/assets/934af6fa-62c9-4bdb-b244-b167e104e2e0" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 51 PM (2)" src="https://github.com/user-attachments/assets/4aababf6-dd14-448a-a418-1a509558378a" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 48 PM" src="https://github.com/user-attachments/assets/8bc23847-e0ab-462b-9d15-53886dbb206e" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 49 PM (1)" src="https://github.com/user-attachments/assets/9f4acffd-aec4-4087-994f-fb4b2c5a50f4" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 47 PM (1)" src="https://github.com/user-attachments/assets/d3ed7c2a-e41a-41b1-b26d-ec753b1bdd31" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 48 PM (2)" src="https://github.com/user-attachments/assets/3d6f3074-7cf9-42be-a551-84e665785cf7" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 48 PM (1)" src="https://github.com/user-attachments/assets/585a44e1-df26-4d31-946c-860375d09473" />
<img width="738" height="1600" alt="WhatsApp Image 2026-04-21 at 10 06 47 PM" src="https://github.com/user-attachments/assets/8de55110-5386-4af4-967d-6aa5e04df21a" />
<img width="1024" height="1024" alt="screen" src="https://github.com/user-attachments/assets/1f41eb14-94c1-45a2-9ac2-d89e4e19c4a6" />

