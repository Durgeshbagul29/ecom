🛍️ ECom App (Powered by BSquare Softwares)

An advanced E-commerce Application built using Flutter & Dart with Firebase backend, supporting Mobile App and Web App platforms.
This application provides smooth experiences for Customers and powerful tools for Admins with secure authentication, product management, and order handling.

🚀 Features
👤 Customer

🔑 Secure Login & Signup (Email/Password, Google Authentication)
🛒 Browse Products with Categories & Search
📦 Add to Cart & Wishlist
💳 Checkout with Integrated Payment Gateway
📜 Order History & Tracking
🔔 Push Notifications (via Firebase Cloud Messaging)

🛠️ Admin

🔑 Role-based Login
📊 Dashboard with Sales & User Analytics
📦 Product Management (Add, Edit, Delete)
🛒 Order Management (Approve, Reject, Update Status)
👥 Customer Management
📢 Manage Promotions & Offers
🌐 Web Admin Panel (Firebase Hosting)

🏗️ Tech Stack
Frontend: Flutter (Dart) – Cross-platform Mobile & Web
Backend: Firebase (Firestore, Authentication, Storage, Cloud Functions)
Notifications: Firebase Cloud Messaging (FCM)
Hosting: Firebase Hosting

State Management: Provider / GetX

⚙️ Getting Started
1️⃣ Prerequisites
Flutter SDK
Dart
Firebase CLI
Node.js & npm (for Firebase Hosting & Functions)

2️⃣ Clone Repository
git clone https://github.com/bsquare-softwares/ecom-app.git
cd ecom-app

3️⃣ Install Dependencies
flutter pub get

4️⃣ Configure Firebase
Create a Firebase Project in Firebase Console
Enable Authentication, Firestore Database, Storage, Cloud Functions, and Hosting
Add Firebase config files:
google-services.json → android/app/
GoogleService-Info.plist → ios/Runner/
firebase_options.dart → lib/ (via flutterfire configure)

5️⃣ Run Application
Mobile
flutter run

Web
flutter run -d chrome

6️⃣ Deploy Web App (Admin Panel)
firebase init hosting
firebase deploy

📂 Folder Structure
lib/
├── main.dart
├── models/
├── screens/
│    ├── customer/
│    ├── admin/
├── services/
├── widgets/
└── utils/

👨‍💻 Developed By
Bsquare Softwares
Empowering businesses with smart digital solutions.

🌐 Website: https://bsquare-softwares.netlify.app
✉️ Email: bsquare.bussiness@gmail.com