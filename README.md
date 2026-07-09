# CompareKart 🛒

CompareKart is a premium, clean, and modern Flutter mobile application designed to compare products, pricing, discounts, ratings, and delivery fees across major Indian online shopping platforms, including **Amazon**, **Flipkart**, **Meesho**, **Myntra**, **Croma**, and **Reliance Digital**.

Built with a white background and a sophisticated deep blue primary theme (`#0D47A1`), the application features responsive grid/list search cards, customizable target price notifications, and a multi-product side-by-side comparison matrix.

---

## 🌟 Main Features

1. **Clean & Modern UI**: Built with a clean white canvas, deep blue theme controls, custom Outfit typography, and subtle box shadows.
2. **Mock Authentication System**: Standard email/password forms and a mock Google Sign-In button that logs you in with a single tap.
3. **Advanced Product Search**: Comprehensive search functionality querying electronics, fashion, footwear, and home appliances.
4. **Platform Price Matrix**: Instantly compares a selected product across multiple stores on a vertical stack, highlighting the **"BEST DEAL"** store.
5. **Multi-Product Compare Queue**: Adds up to 3 separate products to a circular compare queue to analyze them side-by-side in a horizontal scroll table.
6. **Smart Search Filters**: Sort results on the fly by **Lowest Price**, **Highest Rating**, and **Best Discount**.
7. **Interactive Price Drop Alerts**: Users can define target price parameters and use the custom **"Simulate Drop"** trigger to watch alerts transition into triggered notification badges instantly.
8. **Wishlist**: Toggles items on/off favorites.
9. **Profile Dashboard**: Features custom toggle configurations (Dark Mode, notification preferences) and account stats summaries.

---

## 📂 Project Structure

```text
compare_kart/
├── pubspec.yaml            # Project dependencies and configurations
└── lib/
    ├── main.dart           # App entry point, MultiProvider configurations, and app theme
    ├── models/
    │   ├── product.dart       # Product schema (price, ratings, store links)
    │   ├── price_alert.dart   # Alert notifications schema
    │   └── user_profile.dart  # Authenticated user profiles
    ├── services/
    │   └── mock_product_service.dart # Simulated platform scraping engine
    ├── providers/
    │   ├── auth_provider.dart        # Manages Email & Google login states
    │   ├── wishlist_provider.dart    # Manages liked favorites lists
    │   ├── price_alert_provider.dart # Triggers simulated alert thresholds
    │   └── comparison_provider.dart  # Manages the compare queue (Max 3 items)
    ├── screens/
    │   ├── auth_screen.dart           # Authentication UI
    │   ├── main_layout.dart           # Bottom navigation layout
    │   ├── home_screen.dart           # Category links, banner sliders, search bar
    │   ├── search_results_screen.dart # Filter tabs and sorted listings
    │   ├── compare_screen.dart        # Compare queue dashboard / store lists
    │   ├── wishlist_screen.dart       # Favorites lists
    │   ├── price_alerts_screen.dart   # Set thresholds and price drop simulators
    │   └── profile_screen.dart        # Preferences switches and stats counters
    └── widgets/
        ├── custom_search_bar.dart     # Custom shadow search text input
        ├── product_card.dart          # Search item list representation card
        ├── platform_price_row.dart    # Comparison item horizontal list row
        └── alert_dialogs.dart         # Set Price Alert popup widget
```

---

## 🚀 How to Run the App

Follow these instructions to run CompareKart locally on your computer:

### 1. Prerequisites
You must have the **Flutter SDK** and its dependencies installed:
- Download the SDK for Windows from [flutter.dev](https://flutter.dev/docs/get-started/install/windows).
- Extract the zip file and add the `bin` folder (e.g. `C:\src\flutter\bin`) to your user's `PATH` environment variable.
- Run `flutter doctor` in a terminal/command prompt to verify your system status.

### 2. Set Up the Project
Open a shell terminal in the project's root folder:
```powershell
cd d:\m
```

### 3. Fetch Dependencies
Install the package requirements configured in `pubspec.yaml` (such as `provider` and `google_fonts`):
```bash
flutter pub get
```

### 4. Run the Project

#### Option A: Run via Streamlit (Recommended & Instant)
Since Streamlit is fully installed on this system, you can run the web version of CompareKart immediately.
1. Install pandas (if not already present):
   ```bash
   pip install pandas
   ```
2. Launch the Streamlit application:
   ```bash
   streamlit run app.py
   ```

#### Option B: Run via Flutter (Mobile/Chrome)
Ensure you have a target device (plugged-in smartphone, simulator, or web browser) active, then execute:
```bash
flutter run
```

If you do not have mobile simulators installed, you can easily spin up the app in Google Chrome:
```bash
flutter run -d chrome
```

