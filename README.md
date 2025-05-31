## 📱 How to Use the App

**HireSwift** is a mobile application designed to connect recruiters and job seekers via a location-based job portal.

### 🔐 Login & Sign Up

- Users choose their role—**Recruiter** or **Seeker**—via segmented control.
- Based on the role, users sign up with a username and password.
- Once registered, users log in to access role-specific features.
- A "Back" button on all screens lets users safely exit to the login screen.

---

## 👩‍💼 Recruiter Functionality

Recruiters can create job postings using an interactive map.

### 📌 Post a Job

- Enter a job **title** and **description**.
- Tap on the map to **drop a pin** at the job location.
- Tap **Post** to submit — jobs are stored locally using **SwiftData**.
- A confirmation message is displayed on successful post.

---

## 👨‍💻 Seeker Functionality

After login, seekers access a **tab bar** with:
- **Job List**
- **Applied Jobs**

### 📍 Job List Page

- **Filter Nearby Jobs:** Enter a distance in miles and tap the map to choose a reference point.
- **Map Interaction:** The tapped location becomes the filtering reference.
- **Job View:** Jobs matching the filter appear in a table view.
- **Apply:** Tap a job to view details and apply with one tap.

### ✅ Applied Jobs Page

- Displays all jobs the user has applied to.
- Helps seekers track their applications.

---

## 🛠 Development Environment

- **Xcode Version:** 16.2
- **Test Devices:**
  - iPhone SE (3rd Gen) – Simulator (iOS 18.3.1)
  - iPhone 16 Pro – Simulator (iOS 18.3.1)
  - iPhone 13 – Physical Device (iOS 18.4.1)

---

## ✅ Implementation Summary

### 📦 UIKit-Based Views

- `Login/Signup View`
- `Recruiter Job Posting View`
- `Seeker Job List View`
- `Seeker Job Detail + Apply View`
- `Seeker Applied Jobs View`

### 🧭 Navigation & Controllers

- `UINavigationController`: Handles screen transitions and logout.
- `UITabBarController` (`JobTabBarController`): Manages the seeker’s Job List and Applied Jobs.

### 🔧 Frameworks Used

- **UIKit**
- **CoreLocation** – for distance-based filtering and user location
- **MapKit** – for map interaction and job pin display
- **SwiftData** – for local persistence of job posts and applications

---

## 💾 Feature-to-File Mapping

### 🔑 Login & Role Selection

- `LoginViewController.swift`: Login & navigation by role
- `SignUpViewController.swift`: Account creation for Recruiters/Seekers

### 👩‍💼 Recruiter Features

- `RecruiterViewController.swift`: Job creation with map-based location
- `Note.swift`: SwiftData model for job posts

### 👨‍💻 Seeker Features

- `SeekerViewController.swift`: Job filtering, table view display, map interaction
- `JobDetailViewController.swift`: View details & apply to jobs
- `MyApplicationsTableViewController.swift`: List of applied jobs
- `AppliedJob.swift`: SwiftData model for applications

### 🗺 Map & Storage Integration

- **MapKit + CoreLocation** used in:
  - `RecruiterViewController.swift`
  - `SeekerViewController.swift`
- `ModelContext` handles local data interactions
