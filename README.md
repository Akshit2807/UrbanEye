

---

```markdown
# 👁️ UrbanEye – Smart Civic Issue Reporting App

> A Flutter-based mobile application to help civilians easily report civic issues like potholes, garbage dumps, or open sewage. Powered by Firebase for backend services and Flask AI for real-time image classification.

---

## 🚀 Features

### 👥 User Roles
- **Civilian Login:** Report issues with AI-generated descriptions and route them to the appropriate service (Government, NGO, or Private Workers).
- **Social Worker Login:** View and accept issue requests, manage tasks, and track analytics based on your role type.

### 📸 Civilian Workflow
1. Capture or select an image of the civic problem.
2. AI (via Flask) analyzes the image to:
   - **Classify** the issue type (e.g., garbage, pothole)
   - **Generate** a description
3. User can **edit or approve** the description.
4. Choose a resolution path:
   - **Government Agency:** Auto-notify or redirect to official portal.
   - **NGO:** Notifies nearby NGOs who can accept/decline.
   - **Private Worker:** Shows a list of local social workers available for hire.

### 🧑‍🔧 Social Worker Features
- Login with role (Govt, NGO, Private).
- Dashboard for pending issue requests.
- Accept/reject and update status.
- Leaderboards based on contribution and ratings.
- Personal analytics and performance metrics.

### 📊 Additional Features
- Firebase Auth (civilian & worker login)
- Firestore for real-time data storage
- Firebase Messaging for push notifications
- Flask-based AI for smart image classification
- Leaderboards, ratings & feedback system
- Role-specific dashboards with analytics

---

## 🛠️ Tech Stack

| Layer              | Technology        |
|--------------------|-------------------|
| **Frontend**       | Flutter            |
| **AI Backend**     | Flask (Python)     |
| **Authentication** | Firebase Auth      |
| **Database**       | Firebase Firestore |
| **Notifications**  | Firebase Messaging |
| **State Mgmt**     | Provider / MVVM    |
| **Image Tools**    | image_picker, camera |
| **Geo Services**   | geolocator         |

---

## 🧱 Project Structure - MVVM


---

## 🔄 App Workflow Summary

### ➤ Civilian
- Login → Pick Image → Flask AI → Edit Description → Choose Govt/NGO/Worker → Submit

### ➤ Social Worker
- Login → View Requests → Accept/Reject → Complete Task → Track Metrics & Ratings

---

## 📦 How to Run the Project

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/urbaneye.git
   cd urbaneye
````

2. **Set up Firebase**

   * Create a Firebase project.
   * Download `google-services.json` and place it in `/android/app/`.

3. **Install Dependencies**

   ```bash
   flutter pub get
   ```

4. **Run Flask AI Server**

   ```bash
   cd ai-server
   python app.py
   ```

5. **Launch the Flutter App**

   ```bash
   flutter run
   ```

---

## ✅ In Progress / Upcoming

* [ ] Display map of nearby registered workers
* [ ] Email/SMS integration for government agency alerts
* [ ] Offline-first issue reporting
* [ ] Multilingual support

---


