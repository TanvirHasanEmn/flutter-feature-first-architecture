# Production-Grade Flutter Feature-First Architecture

Because the production apps I build belong to clients, I can't share their code on GitHub publicly. I created this project as a practical reference for fellow developers seeking production-level patterns, and to invite feedback from engineering teams evaluating my architectural approach.

It showcases how I design systems to keep a codebase scalable, reduce complexity, and make it easy to add features and maintain over time.

---

## 1. Why This Architecture?

This project follows a **`Feature-First`** approach, often referred to in the Flutter community as **`pragmatic clean architecture`** (popularized by **`Andrea Bizzotto`** / CodeWithAndrea).

**`Uncle Bob’s classic Clean Architecture`**—with separate use cases, entities, and strict abstraction layers—is great for very large enterprise systems with complex business rules. But for most mobile applications, that level of layering often introduces more boilerplate than actual value.

For general projects, a feature-first structure hits the sweet spot. It keeps related code grouped together, separates UI from data and logic cleanly, and lets teams add features quickly without getting bogged down in unnecessary files.

---

## 2. Architecture & Data Flow

This project strictly enforces **Separation of Concerns (SoC)** by isolating foundational infrastructure from feature-specific domains:

* **`lib/core/`:** Core components, network clients, design tokens, and utilities shared globally across the app.
* **`lib/features/`:** Domain-driven, self-contained feature modules where each feature owns its models, state controllers, and presentation layer.

[ View (UI) ] ──► [ Presentation Logic / Notifier ] ──► [ Repository Contract ] ──► [ Data Source (API / DB) ]

---

## 3. Project Structure


```text
lib/
├── app.dart                                # MaterialApp.router & global configs
├── main.dart                               # Entry point wrapped in ProviderScope
│
├── core/                                   # Cross-cutting concerns only
│   ├── constants/                          # Assets, storage keys, design tokens
│   ├── localization/                       # JSON translation loader & delegate
│   ├── network/                            # NetworkCaller, endpoints, interceptors
│   ├── router/                             # GoRouter configs, guards, route paths
│   ├── services/                           # Startup state listener & cold-boot router
│   ├── theme/                              # AppColors, ThemeData
│   └── utils/                              # Pure helper functions & validators
│
└── features/                               # Domain-driven feature boundaries
    ├── auth/                               # Authentication domain
    │   ├── controllers/                    # SignIn, SignUp, ResetPassword Notifiers
    │   ├── models/                         # UserModel, AuthState models
    │   ├── repositories/                   # AuthRepository (REST, OAuth)
    │   ├── views/                          # SignInView, SignUpView, OtpView
    │   └── widgets/                        # SocialAuthButton, LocalAuthFields
    │
    ├── my_booking/                         # Booking & reservation domain
    │   ├── controllers/                    # MyBookingController, ReviewController
    │   ├── models/                         # BookingModel, ReviewModel
    │   ├── views/                          # MyBookingView, CancelView, ReviewView
    │   └── widgets/                        # ActiveCard, CompletedCard, CancelledCard
    │
    ├── Message/                            # Real-time WebSocket messaging
    │   ├── controllers/                    # ChatWebSocketController (State & lifecycle)
    │   ├── models/                         # ChatMessage, ConversationItem
    │   └── views/                          # AllMessagesView, ChatPage
    │
    ├── home/                               # Catalogue & service discovery
    │   ├── controllers/                    # HomeController, FilterController, SlotController
    │   ├── models/                         # ServiceItem, PromoItem, FilterState
    │   ├── views/                          # HomeView, CheckoutView, DateBookingView
    │   └── widgets/                        # CategoryCard, PromoCard, FilterBottomSheet
    │
    ├── nav/                                # App navigation shell
    │   ├── controllers/                    # NavController (Active index state)
    │   └── views/                          # MainNavView (IndexedStack tab persistence)
    │
    ├── notification/                       # User alerts & segment filter
    │   ├── controllers/                    # NotificationController
    │   ├── models/                         # NotificationItem
    │   └── views/                          # NotificationView
    │
    ├── onboarding/                         # First-run experience
    │   ├── controllers/                    # OnboardingController
    │   ├── views/                          # OnboardingView
    │   └── widgets/                        # CurvedClipper
    │
    ├── payment/                            # Payment integration
    │   ├── controllers/                    # PaymentController
    │   ├── models/                         # PaymentBookingArgs (Typed route params)
    │   ├── views/                          # PaymentMethodView
    │   └── widgets/                        # PaymentBottomSheet
    │
    └── profile/                            # User settings, FAQ & account actions
        ├── controllers/                    # ProfileController, FaqController
        ├── views/                          # ProfileView, EditProfileView, FaqView
        └── widgets/                        # LogoutBottomSheet

```
---

## 4. Production Tech Stack & Practical Decisions

Instead of using packages randomly, I pick tools that balance long-term stability, minimal boilerplate, and team velocity:

* **State Management — `flutter_riverpod` (Notifiers):** Hits the sweet spot for maintainability and testability. It gives the deterministic safety of BLoC without the mountain of boilerplate, while staying far more predictable than GetX. *(I still reserve BLoC for specific legacy or strict event-driven systems).*
  
* **Routing — `go_router`:** Handles declarative routing, deep-linking, typed redirects, and smooth auth state redirects right from cold boot.
  
* **Networking — `dio` / `http`:** Configured with centralized interceptors, automatic JWT refresh flows, and normalized error mapping to keep UI code free from raw HTTP logic.
  
* **Models & Serialization:** Standard typed Dart models with `fromJson` / `toJson`, using `@freezed` where immutable union states and pattern matching make handling UI states cleaner.
  
* **Local Storage & Security:**
  * `flutter_secure_storage`: Encrypted storage for sensitive tokens and API keys.
  * `shared_preferences`: Simple key-value storage for small flags and UI preferences.
  * `drift` / `sqlite`: Used when an app genuinely needs offline-first relational queries and indexing.
    
* **Realtime & Notifications:**
  * **WebSockets (`web_socket_channel`):** Custom connection management with heartbeat and auto-reconnect handling for live feeds and chat.
  * **FCM (Firebase Cloud Messaging):** Reliable background, foreground, and terminated state notification handling.
* **Screen Adaptability & Responsiveness:** Built using ratio-based constraints, `LayoutBuilder`, and `MediaQuery.sizeOf` instead of hardcoded screen scalers, so screens look natural across phones and tablets without awkward stretching.
  
* **UI Polish & Feedback:**
  * **`skeletonizer`:** Creates bone-accurate loading skeletons directly from actual widgets, saving time from building duplicate mock skeleton layouts.
  * **`flutter_svg` / WebP:** Vector assets for icons and branding to keep the binary size tight; compressed WebP/PNG for complex visuals.
  * **`google_fonts`:** Loaded and cached cleanly inside the global theme layer.
  * **Lottie / Rive:** Lightweight animations for onboarding and empty states.
    
* **Native Setup:** `flutter_native_splash` and `flutter_launcher_icons`, with manual native XML/storyboard adjustments so cold boots launch with zero jank or white-flash.
  
* **Diagnostics — `logger`:** Clean, categorized, color-coded logging that automatically strips out in production release builds.
  
* **Third-Party Integrations:** Google Maps, geolocation tracking, WebRTC streaming (Agora/Jitsi), and in-app monetization (Stripe, Google Pay, RevenueCat).

---

## 5. Testing Strategy & Quality Assurance

I treat testing as a safety net for business logic and long-term refactoring, rather than chasing vanity metrics like 100% line coverage on simple UI widgets.

### Automated Testing Suite
* **Unit Tests (Core Focus):** Priority goes to domain logic, state notifiers, data mappers, and repository implementations. I write unit tests to verify state transitions under both success and edge-case failure scenarios.
* **Widget & Component Tests:** Used for reusable, critical UI components (like custom input fields, error banners, or complex interactive cards) tested in isolation using mocked dependencies.
* **End-to-End & Integration:** Validates core user journeys (such as the auth lifecycle and checkout/submission flows) without touching real production servers.
* **Target Coverage:** ~80%+ coverage concentrated on business logic, state management, and critical data parsing where regressions are most costly.

### Profiling with Flutter DevTools
Automated tests catch logic bugs, but Flutter DevTools catch performance bugs. In my regular QA workflow, I rely heavily on:
* **Flutter Inspector:** Inspecting widget trees, layout constraints, and eliminating unnecessary rebuilds.
* **Performance & Frame Profiling:** Tracking frame rendering times (aiming for consistent 60/120 FPS) and catching shader compilation jank or heavy build methods.
* **Memory & Allocation:** Checking for retained objects, image cache bloat, and unclosed streams or controllers to prevent memory leaks before release.
* **Network View:** Auditing payload sizes, header configurations, and HTTP status handling in real time.

---

## 6. CI/CD & Dev Automation

Writing good code is only half the job; catching issues before they hit master or production is just as critical. I set up automated pipelines and strict code standards right from the start.

### Continuous Integration (GitHub Actions)
Every pull request triggers an automated CI pipeline that acts as a quality gate before any branch can be merged:
* **Code Formatting:** Runs `dart format --output=none --set-exit-if-changed` to guarantee consistent styling across the team without manual nitpicks in PR reviews.
* **Static Analysis:** Runs `flutter analyze` with zero tolerance for warnings or loose typing.
* **Test Suite:** Executes unit and widget tests automatically (`flutter test --coverage`) to verify no regressions were introduced.

### Strict Code Quality & Linting
I configure a customized `analysis_options.yaml` on top of `flutter_lints` to enforce clean habits early:
* Prohibits `avoid_dynamic_calls` and discourages untyped variables to prevent runtime crashes.
* Requires explicit return types and parameter types for clear readability.
* Enforces `prefer_const_constructors` and `prefer_const_declarations` across widgets to optimize render rebuilds and garbage collection.

### Environment & Flavor Management
To keep test data and staging environments completely isolated from real users:
* **Flavors / Schemes:** Structured with dedicated targets (`dev`, `staging`, `prod`) using separate bundle IDs / package names (e.g., `com.app.dev` vs `com.app`). This allows developers and QA testers to keep both the test build and the live production app installed on the same device simultaneously.
* **Configuration & Secrets:** Sensitive API keys, endpoints, and environment variables are injected at build time using `--dart-define` / `--dart-define-from-file` and `.env` configs, keeping secret credentials out of public version control.

---

## 7. Future Scope & Architectural Enhancements

While this repository demonstrates the core architecture and separation of concerns, here are the key production upgrades planned for upcoming iterations:

* **Code Generation with `riverpod_generator`:** Transition manual `NotifierProvider` declarations to functional `@riverpod` annotations to take advantage of compile-time dependency graph safety and streamlined family parameter handling.
* **Automated Offline Sync Queue:** Implement a persistent FIFO action queue (using background tasks via `workmanager`) to store user actions—like bookings or offline form submissions—and replay them automatically once connectivity restores.
* **Biometric & Hardware Authentication:** Add local biometric authentication (`local_auth`) using secure enclave storage for quick, biometric-gated app unlock flows.
* **Automated Store Deployment (Fastlane):** Extend the existing GitHub Actions CI checks to include automated CD distribution straight to TestFlight and Google Play Internal App Sharing tracks.
* **Visual Regression & Golden Testing:** Introduce `alchemist` or `golden_toolkit` tests for core reusable design-system components to catch accidental UI regressions across platform updates.
