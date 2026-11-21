# Student Management App

A cross-platform **Flutter Student Management App** for registering, viewing, searching, editing, and deleting student records. Built with Flutter and Material 3, with local data persistence so student information is available when the app is reopened.

## Features

- **Dashboard:** View the total number of registered students.
- **Register students:** Add a student with roll number, full name, age, gender, course/department, email, and phone number.
- **View student records:** Browse all registered students in a list.
- **Search:** Filter students by name, roll number, or course.
- **Student details:** Open an individual record to see its academic and contact information.
- **Edit records:** Update an existing student's information.
- **Delete records:** Remove a student after confirming the action.
- **Form validation:** Required fields and basic email, age, and phone validation help prevent incomplete or invalid records.
- **Local persistence:** Student data is stored locally; no remote backend or account is required.

## Tech Stack

| Technology | Purpose |
|---|---|
| [Flutter](https://flutter.dev/) | Cross-platform application UI |
| [Dart](https://dart.dev/) | Application programming language |
| Material 3 | UI components and theming |
| [SQLite / sqflite](https://pub.dev/packages/sqflite) | Local database on supported native platforms |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi) | SQLite support through FFI |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Local preferences support |

The project includes separate native and web database backends. Data is stored locally on the device/browser and is not automatically synchronized between devices.

## Project Structure

```text
student-management-app/
├── android/                 # Android platform project
├── ios/                     # iOS platform project
├── linux/                   # Linux platform project
├── macos/                   # macOS platform project
├── web/                     # Web platform project
├── windows/                 # Windows platform project
├── lib/
│   ├── database/
│   │   ├── database_backend_native.dart
│   │   ├── database_backend_web.dart
│   │   └── database_helper.dart
│   ├── models/
│   │   └── student.dart
│   ├── screens/
│   │   ├── add_edit_student_screen.dart
│   │   ├── home_screen.dart
│   │   ├── student_detail_screen.dart
│   │   └── student_list_screen.dart
│   ├── widgets/
│   │   ├── empty_state.dart
│   │   └── student_card.dart
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK 3.0 or later)
- A supported development environment, such as Android Studio or Visual Studio Code
- An emulator, simulator, browser, or connected device for your target platform

Verify your Flutter installation:

```bash
flutter doctor
```

### 1. Clone the repository

```bash
git clone https://github.com/Hari-544/student-management-app.git
cd student-management-app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

For the default connected device:

```bash
flutter run
```

To run on a specific target, first check available devices:

```bash
flutter devices
```

Then specify the device ID:

```bash
flutter run -d <device_id>
```

For web (if Chrome is installed and enabled in Flutter):

```bash
flutter run -d chrome
```

## Build

Create a release build for your target platform using the relevant command:

| Platform | Command |
|---|---|
| Android APK | `flutter build apk --release` |
| Android App Bundle | `flutter build appbundle --release` |
| Web | `flutter build web --release` |
| Windows | `flutter build windows --release` |
| Linux | `flutter build linux --release` |
| macOS | `flutter build macos --release` |
| iOS | `flutter build ios --release` |

Build output is generated in the corresponding subdirectory under `build/`. Platform builds require the relevant platform toolchain; for example, iOS builds require macOS and Xcode.

## Student Information

Each student record contains:

| Field | Description |
|---|---|
| Roll Number | Unique student identifier |
| Full Name | Student's name |
| Age | Student's age |
| Gender | Male, Female, or Other |
| Course / Department | Academic course or department |
| Email Address | Student's email |
| Phone Number | Student's contact number |

## Data & Privacy

- Records are stored locally using the platform-specific database backend.
- The app does not require a login or remote server.
- Local records are not shared or synchronized across devices.
- Uninstalling the app or clearing browser data may remove locally stored records. Back up any important information before doing so.

## Contributing

Contributions and suggestions are welcome.

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -m "Add your feature"`.
4. Push the branch: `git push origin feature/your-feature`.
5. Open a Pull Request.

## License

No license is currently specified in this repository. Please contact the repository owner before reusing or distributing the project.

---

Developed as a UIDF Flutter Lab project.
