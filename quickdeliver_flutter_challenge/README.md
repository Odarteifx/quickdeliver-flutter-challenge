# 📦 QuickDeliver

**QuickDeliver** is a modern delivery tracking app built with **Flutter** and **Firebase**, designed to help users **place, track, and manage deliveries** seamlessly. It features real-time maps, status updates, and push notifications for an effortless delivery experience.

---

## ✨ Features

- ✅ User authentication (Sign Up / Login)
- ✅ Place new delivery orders with pickup & drop-off locations
- ✅ Google Places Autocomplete for real addresses
- ✅ View all deliveries with live statuses
- ✅ Interactive Google Map with pickup & drop-off markers + route polyline
- ✅ Real-time push notifications via **Firebase Cloud Messaging (FCM)**
- ✅ Order status stepper: Placed → Picked Up → In Transit → Delivered
- ✅ Profile screen with user info
- ✅ Sort deliveries by status
- ✅ Clean, responsive UI using Flutter, ScreenUtil, and Google Fonts

---

## 🚀 Tech Stack

- **Flutter**
- **Firebase Auth**
- **Cloud Firestore**
- **Firebase Cloud Messaging**
- **Google Maps SDK**
- **Google Places API**
- **GoRouter**
- **DotEnv**

---

## 📂 Project Structure

lib/
 ├── core/         # Colors, fonts, router
 ├── screens/      # All UI screens (Login, Signup, Orders, Profile, Details)
 ├── widgets/      # Reusable widgets (buttons, steppers, badges)
 ├── services/     # Firebase & Google Maps services
 ├── main.dart     # App entry point & FCM setup

## ⚙️ Setup Instructions

### 1️⃣ Clone this repo
git clone https://github.com/yourusername/quickdeliver.git
cd quickdeliver

### 2️⃣ Install dependencies
flutter pub get

### 3️⃣ Create .env
GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY


### 4️⃣ Run on iOS
Ensure your ios/Runner/Info.plist includes:

<key>NSLocationWhenInUseUsageDescription</key>
<string>We use this to show your location on the map.</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
</array>

Then run:
cd ios
pod install --repo-update
cd ..
flutter run


## 🔑 Environment Variables
GOOGLE_MAPS_API_KEY — generate this from Google Cloud Console.

## 🔔 Notifications
The app uses Firebase Cloud Messaging (FCM).
FCM token is stored in Firestore for each user after login/signup.
Order status changes trigger push notifications to the user.

## 📝 Brief Note
### If given more time, I would,
 ⬜️ Fix the google maps to function much better with marker animations
 ⬜️ Add driver live tracking
 ⬜️ Delivery cost estimation & payment integration
