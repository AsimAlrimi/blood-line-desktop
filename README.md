# Blood Line

**A Comprehensive Blood Donation Management System**

Blood Line is a platform designed to streamline the blood donation process, enhance communication among stakeholders, and optimize blood bank operations. The system consists of:
- **[Mobile App](https://github.com/AsimAlrimi/blood-line-mobile.git)**  
- **Desktop App**  
- **[Backend](https://github.com/AsimAlrimi/blood-line-backend.git)**  

The mobile app enables donors to easily schedule appointments, track donation history, receive notifications about blood drives, and stay informed about urgent blood supply needs. Meanwhile, hospitals and blood banks utilize the desktop application to manage blood donations and facilitate better communication with donors.

---

## Blood Line Desktop App

### Overview
The Blood Line Desktop App is designed for blood bank administrators and staff to efficiently manage blood donations, track donors, and communicate with stakeholders. It provides real-time insights into donation activities, automates appointment tracking, and facilitates donor engagement through notifications and updates.

### Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **Backend Communication:** REST API (Flask, Python)
- **Database:** SQLite
- **Mapping Services:** Google Maps API

---

## Features

### **User Management**
- **Admin Log In:** Secure login for administrators to manage platform operations and approve or reject blood bank requests to join the system.
- **Register Organization:** Allows blood bank managers to register their organization.
- **Register Staff Members:** Managers can register, delete, and update staff members with role-based access.
- **Manager Log In:** Enables blood bank managers to manage staff and update blood bank information.
- **Staff Log In:** Enables authorized personnel to access the system.

### **Donation & Tracking**
- **View Dashboard:** Displays real-time updates on upcoming appointments and donation status.
- **Track Donation Process:** Staff can monitor donations from registration to collection and storage.
- **Manage Donor Information:** Staff can update donor details and send targeted notifications.
- **View Blood Inventory:** Staff can check current blood stock levels to ensure availability.

### **Home Page & Analytics**
- **Statistics & Charts:** All users have access to a homepage displaying key metrics, trends, and visualized data for better decision-making.

### **Communication & Engagement**
- **Send Notifications:** Staff can create and schedule notifications for blood needs and events.
- **Manage FAQs:** Admins can update frequently asked questions for better user guidance.
- **View Contact Us Information:** Managers can edit contact details to keep them up to date.

---

## Getting Started

### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Dart SDK
- Windows/Linux/macOS (for running the desktop app)

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/AsimAlrimi/blood-line-desktop.git
   ```
2. Navigate to the project directory:
   ```sh
   cd blood-line-desktop
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

