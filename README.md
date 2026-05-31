# 🏫 Smart System for Schools

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)](https://fastapi.tiangolo.com)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)](https://tensorflow.org)
[![Firebase](https://img.linkedin.com/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Stripe-5433FF?style=for-the-badge&logo=Stripe&logoColor=white)](https://stripe.com)

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
│   └── features/                # Domain-Driven Feature Modules (Clean Architecture)
│       ├── Allergies/           # Allergens catalog & student allergy binding
│       ├── Attendance/          # Attendance list and tracking UI
│       ├── chatbot/             # Gemini 1.5 interactive helper chat
│       ├── food_ai_view/        # Gemini 2.0 diet plans and camera analyser
│       ├── payment_parent/      # Transactions history & statements
│       └── splash/              # Animated introductory landing
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

## 📝 License
This project is private and distributed under **None** license. See `pubspec.yaml` (`publish_to: 'none'`) for details.
