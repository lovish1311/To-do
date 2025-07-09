To-Do App (Flutter Cross-Platform)
Project Overview
This is a robust, user-friendly, and feature-rich To-Do application built using Flutter, targeting Android, iOS, and Web platforms. The project focuses on an offline-first approach for personal tasks, with conditional online capabilities for advanced features like task assignment.

Features
Core Functionality
Task Lists (Categories):
a. Create multiple, independent task lists (e.g., "Work," "Personal," "Groceries").
b. Tasks are organized within specific task lists.
c. Full CRUD (Create, Read, Update, Delete) operations for Task Lists.

Individual Tasks:
a. Add, view, edit, and delete tasks within a selected task list.
b. Tasks include a title and description.
c. Tasks can be marked as complete or incomplete.
d. Full CRUD operations for Tasks.

Time Management
Due Dates & Reminders:
a. Assign specific due dates to tasks.
b. Local notifications for due tasks.

Recurring Tasks:
a. Set tasks to recur (Daily, Weekly, Monthly, Custom Interval).

User Experience (UX) & Interface (UI)
Theming:
a. Supports both Light Mode and Dark Mode, with user preference options.

Responsiveness:
a. Fully optimized UI for mobile (Android/iOS) and web (desktop/mobile browser).

User Authentication:
a. Not mandatory for personal tasks (offline-first). Required only for "Assigned Task" feature (Firebase integration).

Advanced/Unique Task Types
Wish Task Feature:
a. A distinct task type with a deadline.
b. Prompts for specific completion statuses: "Completed," "Not Completed," "Delayed."
c. If "Delayed," prompts further categorization: "So regret it?" or "I was doing some important work."

Assigned Task Feature (Teacher-Student Model):
a. Users (assigners) can assign task lists or individual tasks to other users (assignees).
b. Assigners can view assigned task status.
c. Assignees can update their assigned task status.
d. Each assigned task has a deadline.
e. Requires Firebase for authentication, real-time data, and user management.

Architecture
a. Framework: Flutter (Cross-platform)
b. Architecture Pattern: MVVM (Model-View-ViewModel)
c. State Management: provider package (ChangeNotifierProvider, Consumer)
d. Local Data Persistence: Hive database (offline-first focus)
e. Online Data Persistence (Conditional): Firebase (Firestore, Firebase Auth) for "Assigned Task" feature.

Project Structure (Current & Planned)
to_do/
├── lib/
│   ├── main.dart             # Application entry point, Hive initialization, global providers
│   ├── models/               # Data models (e.g., TaskList, Task, WishTask)
│   │   ├── task_list.dart
│   │   └── task_list.g.dart  # Generated Hive adapter for TaskList
│   ├── services/             # Data interaction logic (e.g., TaskListService)
│   │   └── task_list_service.dart
│   ├── viewmodels/           # State management logic (e.g., TaskListViewModel)
│   ├── views/                # UI widgets/screens (e.g., TaskListsScreen)
│   │   │   └── screens/
│   │   │   └── widgets/
│   │   └── ...
│   └── utils/                # Utility functions, constants, helpers
│       └── constants.dart    # Centralized constants (e.g., Hive box names)
├── pubspec.yaml              # Project dependencies and metadata
├── README.md                 # This file
└── ... (other Flutter project files)

Setup & Running the Application
Prerequisites
a. Flutter SDK installed (version ^3.8.1 or compatible)
b. Dart SDK (comes with Flutter)
c. An IDE (VS Code with Flutter extension or Android Studio)

Installation Steps
Clone the repository:

git clone https://github.com/lovish1311/to-do-app.git
cd to-do-app

Fetch dependencies:
This command will download all required packages as specified in pubspec.yaml.

flutter pub get

Generate Hive adapters:
This step is crucial for Hive to properly serialize and deserialize your data models.

flutter packages pub run build_runner build

(If you encounter Already running, use flutter packages pub run build_runner build --delete-conflicting-outputs)

Run the application:

flutter run

Choose your target device (Android emulator, iOS simulator, or Chrome for web).





