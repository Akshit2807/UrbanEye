<div align="center">

  <br />
  <br />

  <!-- You can add a logo here if you have one -->
  <!-- <img src="URL_TO_YOUR_LOGO" alt="UrbanEye Logo" width="200"/> -->

  # 🏙️ UrbanEye: Smart City Reporting 🏙️

  **Bridging the gap between citizens and city authorities for a smarter, cleaner, and more efficient urban environment.**

  ---

  <!-- Badges -->
  <p>
    <a href="#"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg"/></a>
    <a href="#"><img alt="Flutter" src="https://img.shields.io/badge/Frontend-Flutter-blue.svg?logo=flutter"/></a>
    <a href="#"><img alt="Flask" src="https://img.shields.io/badge/Backend-Flask-black.svg?logo=flask"/></a>
    <a href="#"><img alt="Firebase" src="https://img.shields.io/badge/Database-Firebase-orange.svg?logo=firebase"/></a>
    <a href="#"><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/Akshit2807/UrbanEye.svg"/></a>
    <a href="#"><img alt="GitHub issues" src="https://img.shields.io/github/issues/Akshit2807/UrbanEye.svg"/></a>
  </p>
</div>

---

## 🚀 Introduction

**UrbanEye** is a mobile application designed to empower citizens to report civic issues directly to their local authorities. From potholes and broken streetlights to waste management problems, UrbanEye provides a seamless platform to capture, report, and track issues, fostering transparency and collaboration for better city living.

Our mission is to leverage technology to make our cities more responsive, accountable, and ultimately, more livable for everyone.

---

## 🎥 Demo Video & Live Link

<table>
<tr>
<td width="50%" valign="top">

Check out our project in action!

- **Watch the Project Demo & Intro Video:** [**Link to Your Video**](https://youtu.be/1qoraqzspt4)  
- **Explore the Live Website/Platform:** [**Link**](https://urban-eye-jfcf.vercel.app/)

👉 *Click the image to open the website!*

</td>
<td width="50%">

<a href="https://urban-eye-jfcf-3a9x5uwfu-akpahade55-9707s-projects.vercel.app/">
  <img src="https://github.com/Akshit2807/UrbanEye/blob/main/demo/UE-website.png?raw=true" width="100%"/>
</a>

</td>
</tr>
</table>



---

## ✨ Key Features

* **📸 Easy Issue Reporting:** Snap a photo, add a description, and automatically tag the location.
* **📍 GPS Integration:** Automatically captures the exact location of the issue using GPS.
* **🚦 Real-Time Tracking:** Monitor the status of your reported issues from "Submitted" to "Resolved".
* **👤 User Authentication:** Secure sign-up and login for personalized user experience.
* **💬 Notifications:** Get notified about updates on your reported issues.
* **🗺️ Interactive Map View:** See all reported issues in your area on an interactive map.
* **📊 Dashboard for Authorities:** (Conceptual) A web dashboard for city officials to view, manage, and respond to reported issues.

---

## 📱 App Screenshots

Here's a sneak peek into the UrbanEye app interface.

| Welcome Screen | Report an Issue | Issue Tracking |
| :---: | :---: | :---: |
| <a href="https://youtu.be/1qoraqzspt4" target="_blank"><img src="https://github.com/Akshit2807/UrbanEye/blob/main/demo/UE-demo-1.jpg" alt="Welcome Screen" width="250"></a> | <a href="https://youtu.be/1qoraqzspt4" target="_blank"><img src="https://github.com/Akshit2807/UrbanEye/blob/main/demo/UE-demo-3.jpg" alt="Report an Issue" width="250"></a> | <a href="https://youtu.be/1qoraqzspt4" target="_blank"><img src="https://github.com/Akshit2807/UrbanEye/blob/main/demo/UE-demo-2.jpg" alt="Issue Tracking" width="250"></a> |
| *A vibrant welcome screen to greet users.* | *Simple and quick issue reporting.* | *Track the status of your reports.* |



---

## 🛠️ Tech Stack

UrbanEye is built with a modern and scalable tech stack.

### **Frontend (Mobile App)**
* **[Flutter](https://flutter.dev/)**: For building a high-performance, cross-platform mobile application from a single codebase.
* **[Dart](https://dart.dev/)**: The programming language for Flutter.
* **Key Packages**:
    * `firebase_core` & `cloud_firestore`: For direct communication with Firebase.
    * `http`: For making API requests to the backend.
    * `google_maps_flutter`: For displaying interactive maps.
    * `geolocator`: For fetching the device's GPS location.

### **Backend (Server)**
* **[Flask](https://flask.palletsprojects.com/)**: A lightweight Python web framework for our REST API (for processing, notifications, etc.).
* **[Python](https://www.python.org/)**: The core language for the backend logic.
* **[Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)**: For secure communication between the Flask server and Firebase.

### **Database**
* **[Firebase](https://firebase.google.com/)**: Using **Cloud Firestore** for a flexible, scalable NoSQL database and **Firebase Authentication** for user management.


## ⚙️ Getting Started

To get a local copy up and running, follow these simple steps.

### **Prerequisites**

* **Firebase Project**: Create a new project on the [Firebase Console](https://console.firebase.google.com/).
* **Flutter SDK**: [Installation Guide](https://flutter.dev/docs/get-started/install)
* **Python 3.x**: [Download Python](https://www.python.org/downloads/)
* A code editor like VS Code or Android Studio.

### **Backend Setup**

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/Akshit2807/UrbanEye.git](https://github.com/Akshit2807/UrbanEye.git)
    cd UrbanEye/backend  # Navigate to the backend folder
    ```
2.  **Setup Firebase Admin SDK:**
    * In your Firebase project settings, go to `Service accounts`.
    * Click "Generate new private key" and download the JSON file.
    * **Securely** place this file in your backend directory (e.g., as `serviceAccountKey.json`) and add it to your `.gitignore` file to keep it private.
3.  **Create a virtual environment:**
    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```
4.  **Install dependencies:**
    ```sh
    pip install -r requirements.txt
    ```
5.  **Run the Flask server:**
    ```sh
    flask run
    ```

### **Frontend Setup**

1.  **Navigate to the frontend folder:**
    ```sh
    cd ../frontend # Or your flutter app directory name
    ```
2.  **Configure Firebase for Flutter:**
    * Follow the [FlutterFire installation guide](https://firebase.flutter.dev/docs/overview#installation) to connect your Flutter app to your Firebase project. This will involve adding a `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to your app.
3.  **Get Flutter packages:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```
    Connect a device or use an emulator, and the app will build and run.

---

## 🤝 How to Contribute

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 📬 Contact

Akshit - [@akshit-pahade](https://www.linkedin.com/in/akshit-pahade/) - akpahade55@gmail.com

Project Link: [https://github.com/Akshit2807/UrbanEye](https://github.com/Akshit2807/UrbanEye)

<div align="center">
  <br />
  <p>Made with ❤️ for better cities.</p>
</div>
