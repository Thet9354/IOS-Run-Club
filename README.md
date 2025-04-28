# 🏃‍♂️ RunClub

RunClub is a Swift-based iOS app designed for runners to easily track, store, and view their runs.  
It integrates **MapKit** for real-time route tracking, **Supabase** for secure user authentication and data storage, and **HealthKit** for syncing workouts with the iPhone Health app.

---

## ✨ Features

- **Home View + MapKit Integration**  
  View your current location and track your running route in real time.

- **Run Tracker**  
  - Countdown timer before starting a run (get ready!).
  - Track time, distance, and pace throughout your run.
  - Pause and resume your run whenever needed.

- **Authentication**  
  - **Magic Link Email Login** using Supabase AuthService.
  - Simple and secure sign-in experience with no password required.

- **Run Data Storage**  
  - Save completed runs to a **Supabase Database**.
  - View your past activities in the **ActivityView**.

- **HealthKit Integration**  
  - Sync your workouts to the **Health** app on iPhone.
  - Automatically estimates and saves calories burned during runs.

---

## 🛠️ Tech Stack

- **Swift / SwiftUI**
- **MapKit** — for location tracking and maps.
- **Supabase** — for authentication and backend database.
- **HealthKit** — for Health app workout synchronization.

---

## 📲 Screenshots

| Home View | Countdown | Running Tracker | Activity View | Health App Sync |
|:---:|:---:|:---:|:---:|:---:|
| ![HomeView Screenshot](screenshots/homeview.png) | ![Countdown Screenshot](screenshots/countdown.png) | ![Running Screenshot](screenshots/running.png) | ![ActivityView Screenshot](screenshots/activityview.png) | ![HealthApp Screenshot](screenshots/healthapp.png) |

> Make sure to place your screenshots inside a `/screenshots/` folder in your repo and name them accordingly.

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/RunClub.git
   ```

2. **Open in Xcode**  
   Navigate to the project folder and open `RunClub.xcodeproj`.

3. **Set up Supabase**  
   - Create a Supabase project.
   - Enable **Magic Link Auth**.
   - Set up your **Database** tables for user runs.
   - Add your Supabase project URL and anon/public keys into the app's configuration.

4. **Configure HealthKit**  
   - Ensure HealthKit capabilities are enabled in your Xcode project.
   - Add required permissions to `Info.plist`.

5. **Run on a real device**  
   HealthKit and location tracking require a real iPhone device.

---

## 📚 Folder Structure (Main Parts)

```
RunClub/
├── Views/
│   ├── HomeView.swift
│   ├── ActivityView.swift
├── Services/
│   ├── AuthService.swift
│   ├── DatabaseService.swift
├── Models/
│   ├── Run.swift
├── Health/
│   ├── HealthStore.swift
```

---

## ⚡ Future Improvements

- Social features (share runs with friends)
- Challenges and achievements
- Push notification reminders
- Apple Watch support

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 💬 Acknowledgements

- [Supabase](https://supabase.com/)
- [Apple HealthKit Documentation](https://developer.apple.com/documentation/healthkit)
- [MapKit Documentation](https://developer.apple.com/documentation/mapkit)
