# 🏫 smartSystemForSchools

![GitHub stars](https://img.shields.io/github/stars/OmarAliSiad/smartSystemForSchools?style=for-the-badge&logo=github) ![GitHub forks](https://img.shields.io/github/forks/OmarAliSiad/smartSystemForSchools?style=for-the-badge&logo=github) ![GitHub issues](https://img.shields.io/github/issues/OmarAliSiad/smartSystemForSchools?style=for-the-badge&logo=github) ![Last commit](https://img.shields.io/github/last-commit/OmarAliSiad/smartSystemForSchools?style=for-the-badge&logo=github) ![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white) ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Java (Gradle)](https://img.shields.io/badge/Java%20(Gradle)-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white) ![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white) ![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

A comprehensive, state-of-the-art Flutter mobile application and AI-backend ecosystem designed to bridge the gap between school administration, canteens, and parents. The system offers parent control over child nutrition, health parameters, school payments, real-time location tracking, and instant school-parent communication.

---

## 🌟 Key Features

### 🥦 Health & Nutrition Control
*   **Allergy Management**: Keep track of child allergies (`Peanuts`, `Tree Nuts`, `Milk`, `Eggs`, `Wheat`, `Soy`, `Fish`, `Shellfish`, etc.).
*   **Daily Spending Limits**: Parents can define and update limits on school canteen purchases.
*   **AI Meal Recommendation**: Custom meal guides powered by **Gemini 2.0 Flash** tailored to the child's age, weight, height, blood type, and allergy constraints.
*   **TFLite Food Checker**: On-device TensorFlow Lite model (`food_choice_model.tflite`) for instant local analysis of foods.
*   **Deep Learning Food Analysis**: Python-based FastAPI service leveraging a **MobileNetV2** deep learning model for real-time classification, allergen detection, and calorie reporting.

### 💬 Interactive AI Chatbot
*   **AI School Assistant**: A smart chatbot powered by **Gemini 1.5 Flash** to answer parent inquiries, provide guidance on child health, and retrieve school details.
*   **Local Chat History**: Persistent messaging history using `SharedPreferences`.
*   **Typing Animation & Rich Media**: Streamed typewriter visual feedback with support for image/file attachment contexts.

### 💳 School Payments & Wallets
*   **Stripe Integration**: Secure in-app credit/debit card transactions using `flutter_stripe`.
*   **Transaction Ledger**: Real-time statements for children's canteen purchases and parent top-ups.

### 📍 Child Tracking & Attendance
*   **Live Tracking**: Integrated Google Maps for school bus routing and geolocator services.
*   **Attendance Ledger**: Calendar metrics showing student check-ins and check-outs.

### 🔔 Smart Notification System
*   **Firebase Cloud Messaging (FCM)**: Remote push alerts for canteen confirmations and announcements.
*   **Local Notifications**: Scheduled and high-priority alarms fallback.

### 🌐 Universal Localization & UI
*   **Multi-language Support**: Complete translation engine (Arabic 🇦🇪, English 🇬🇧, Spanish 🇪🇸, French 🇫🇷) with RTL layout handling.
*   **Rich Aesthetics**: Beautiful responsive dashboards with light/dark theme toggles, fluid custom animations, and a modern error overlay layout.

---

## 🛠️ Technology Stack

### Mobile Application (Flutter)
| Technology / Package | Purpose |
| :--- | :--- |
| **Flutter SDK (`^3.5.3`)** | Main cross-platform mobile framework |
| **Flutter BLoC & Equatable** | Clean State Management & predictable state flow |
| **Firebase Services** | Auth, Firestore Database, and Cloud Messaging (FCM) |
| **Dio & Http** | REST API networking client with interceptors |
| **Stripe SDK** | Processing school canteen top-ups and fees |
| **Easy Localization** | Localizing resources dynamically across 4 languages |
| **Google Maps Flutter** | Real-time map overlays for school tracking |
| **Gemini 1.5 & 2.0 Flash** | AI Generative APIs for custom diet guidelines & chatbot services |
| **Flutter Animate & Animate Do** | Premium visual micro-animations and physics-based transitions |
| **SharedPreferences** | Local persistence of app configs and chat histories |

### AI Backend (Python)
| Technology / Package | Purpose |
| :--- | :--- |
| **FastAPI** | High-performance API routing and async request handling |
| **Uvicorn** | ASGI server run environment |
| **TensorFlow & Keras** | MobileNetV2 transfer learning model pipeline for food identification |
| **NumPy & Pillow** | Array manipulations and image preprocessing |
| **Pydantic** | Payload schemas validation and type checks |

---

## 📂 Project Structure

```
smartsystemforschools/
│
├── android/ & ios/              # Native Platform Configurations
├── assets/                      # App Assets
│   ├── fonts/                   # Typography (Poppins, Cairo, Inspiration)
│   ├── images/                  # Icons, logo, and artwork
│   ├── translations/            # Localization dictionaries (ar, en, es, fr)
│   └── food_choice_model.tflite # On-device ML model file
│
├── lib/                         # Flutter App Source Code
│   ├── core/                    # Shared utilities, widgets, services & themes
│   │   ├── connectivity_cubit/  # Global network status tracker
│   │   ├── services/            # Stripe, Firebase, and Auth integrations
│   │   └── themes/              # Light & Dark Theme specs
│   │
│   └───├── features
│   │   ├── Allergies
│   │   │   ├── data
│   │   │   │   ├── food_ai_service.dart
│   │   │   │   └── manager
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── Attendance
│   │   │   ├── attendance_ai_service.dart
│   │   │   ├── data
│   │   │   │   └── manager
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── chatbot
│   │   │   ├── data
│   │   │   │   ├── cubit
│   │   │   │   │   └── ...
│   │   │   │   ├── model
│   │   │   │   │   └── ...
│   │   │   │   └── services
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── chat_bot_screen.dart
│   │   │       └── chat_history_screen.dart
│   │   ├── child_details_view
│   │   │   ├── manager
│   │   │   │   ├── checkout_payment_cubit
│   │   │   │   │   └── ...
│   │   │   │   ├── models
│   │   │   │   │   └── ...
│   │   │   │   └── spending_limit_cubit.dart
│   │   │   │       └── ...
│   │   │   ├── views
│   │   │   │   ├── child_details_view.dart
│   │   │   │   ├── choose_balance_for_child.dart
│   │   │   │   └── spending_limits_view.dart
│   │   │   └── widgets
│   │   │       ├── CardDetailsChildWidget.dart
│   │   │       ├── CustomCardForSpendingAndRecharge.dart
│   │   │       ├── CustomSpendingDailyLimitWidget.dart
│   │   │       ├── buildAllegryChip.dart
│   │   │       ├── custom_allgeries_widget.dart
│   │   │       ├── custom_balance_widget.dart
│   │   │       ├── custom_button.dart
│   │   │       ├── custom_card_spending_limits.dart
│   │   │       ├── custom_card_spending_limits_new.dart
│   │   │       └── restricted_products_widget.dart
│   │   ├── family
│   │   │   ├── data
│   │   │   │   └── manager
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── food_ai_view
│   │   │   ├── data
│   │   │   │   ├── api_handler.dart
│   │   │   │   ├── cubit
│   │   │   │   │   └── ...
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   ├── screens
│   │   │   │   ├── food_ai_screen.dart
│   │   │   │   └── recommdation_screen.dart
│   │   │   └── widgets
│   │   │       └── loading_indicator_widget.dart
│   │   ├── home
│   │   │   ├── data
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── login
│   │   │   ├── data
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   └── presenation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── main_screen
│   │   │   └── presentation
│   │   │       └── views
│   │   │           └── ...
│   │   ├── notification_view
│   │   │   ├── data
│   │   │   │   ├── cubit
│   │   │   │   │   └── ...
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   └── presenation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── onBoarding
│   │   │   ├── views
│   │   │   │   └── pageview.dart
│   │   │   └── widgets
│   │   │       ├── custom_button.dart
│   │   │       ├── custom_page_screen.dart
│   │   │       ├── dot_indicator.dart
│   │   │       └── dots_indicator.dart
│   │   ├── payment
│   │   │   ├── data
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── manager
│   │   │       │   └── ...
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── payment_parent
│   │   │   ├── data
│   │   │   │   ├── cubit
│   │   │   │   │   └── ...
│   │   │   │   ├── models
│   │   │   │   │   └── ...
│   │   │   │   └── services
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── screens
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── schools
│   │   │   └── presentation
│   │   │       └── views
│   │   │           └── ...
│   │   ├── settings
│   │   │   ├── data
│   │   │   │   └── manager
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── settings_view
│   │   │   ├── data
│   │   │   │   └── models
│   │   │   │       └── ...
│   │   │   └── presentation
│   │   │       ├── manager
│   │   │       │   └── ...
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   ├── splash
│   │   │   └── presenation
│   │   │       ├── views
│   │   │       │   └── ...
│   │   │       └── widgets
│   │   │           └── ...
│   │   └── tracking
│   │       ├── data
│   │       │   └── models
│   │       │       └── ...
│   │       └── presentation
│   │           └── views
│   │               └── ...
│   ├── firebase_options.dart
│   ├── generated
│   │   ├── codegen_loader.g.dart
│   │   ├── intl
│   │   │   ├── messages_all.dart
│   │   │   └── messages_en.dart
│   │   ├── l10n.dart
│   │   └── locale_keys.g.dart
│   ├── l10n
│   │   └── intl_en.arb
│   └── main.dart
│
├── food_ai_service.py           # FastAPI Web Application Entrypoint
├── food_recognition_model.py    # TensorFlow ML Model Engine
└── requirements.txt             # Python Backend Dependencies
```

---

## 🚀 Getting Started

### 1. Mobile App Setup
1.  **Install Flutter SDK**: Make sure you have Flutter `>= 3.5.3` installed.
2.  **Clone the Repository**:
    ```bash
    git clone https://github.com/OmarAliSiad/smartSystemForSchools.git
    cd smartSystemForSchools
    ```
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Configure API Keys**: Add your configuration keys to `lib/core/utils/api_keys.dart`.
5.  **Run the App**:
    ```bash
    flutter run
    ```

### 2. Python AI Service Setup
1.  **Navigate to the root directory** and create a virtual environment:
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```
2.  **Install requirements**:
    ```bash
    pip install -r requirements.txt
    ```
3.  **Run the service**:
    ```bash
    python food_ai_service.py
    ```
    The server will spin up locally on `http://0.0.0.0:8000`.

---

## 👥 Contributors

Thanks to everyone who has contributed to this project:

<p align="left">
<a href="https://github.com/OmarAliSiad" title="OmarAliSiad"><img src="https://avatars.githubusercontent.com/u/105920279?v=4&s=64" width="64" height="64" alt="OmarAliSiad" style="border-radius:50%" /></a>
</p>

[See the full list of contributors →](https://github.com/OmarAliSiad/smartSystemForSchools/graphs/contributors)

---

## 👥 Contributing

Contributions are welcome! Here's the standard flow:

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/OmarAliSiad/smartSystemForSchools.git`
3. **Branch**: `git checkout -b feature/your-feature`
4. **Commit**: `git commit -m 'feat: add some feature'`
5. **Push**: `git push origin feature/your-feature`
6. **Open** a pull request

Please follow the existing code style and include tests for new behavior where applicable.

---
