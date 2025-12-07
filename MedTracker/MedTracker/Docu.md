# Technical Documentation

## 1. Application Entry Point

### `MedTrackerApp.swift`
**Purpose:** Serves as the root entry point for the application lifecycle.
**Key Components:**
* `@main`: The entry point for the SwiftUI app.
* `init()`: Automatically requests push notification authorization via `NotificationManager` immediately upon app launch.
* `.modelContainer(for: Medication.self)`: Initializes the SwiftData stack, ensuring the database is ready for injection into the view hierarchy.

## 2. Data Models (SwiftData)

### `Medication.swift`
**Purpose:** Defines the primary data entity for the application.
**Key Properties:**
* `id`: UUID for unique identification.
* `name`, `dosage`, `notes`: String attributes for user details.
* `isActive`: Boolean to toggle reminders without deleting data.
* `reminderTime`: Date object storing the scheduled alert time.
* `frequency`: Enum (`Frequency`) defining the repetition rule (daily, weekly, monthly, interval).
* `imageData`: Binary Data type stored with `@Attribute(.externalStorage)` for performance optimization.
* `logs`: A one-to-many relationship with `IntakeLog`. The delete rule is set to `.cascade`, meaning if a medication is deleted, its history is also deleted.
* `uiImage`: A transient computed property converting the binary `imageData` to a `UIImage` for the UI.

**Extension Logic (`Medication+Logic.swift`):**
* `isTakenToday`: Checks the associated `logs` to determine if an entry exists for the current calendar day.
* `sortedHistory`: Returns the `logs` array sorted by date (newest first).

### `IntakeLog.swift`
**Purpose:** Represents a single historical record of a medication intake.
**Key Properties:**
* `date`: The timestamp of when the medication was taken.
* `medication`: The inverse relationship linking back to the parent `Medication` object.

## 3. Managers & Services

### `NotificationManager.swift`
**Purpose:** A singleton service class responsible for handling all interactions with the `UserNotifications` framework.
**Key Functions:**
* `requestAuthorization()`: Prompts the user for permission to send alerts, sounds, and badges.
* `scheduleNotification(for:)`:
    1.  Cancels any existing notification for the specific medication ID to prevent duplicates.
    2.  Validates that the medication is active and not set to "As Needed".
    3.  Calculates the correct `UNNotificationTrigger` based on the medication's frequency (e.g., `UNCalendarNotificationTrigger` for daily/weekly, `UNTimeIntervalNotificationTrigger` for intervals).
    4.  Schedules the request with the system.
* `cancelNotification(for:)`: Removes pending and delivered notifications associated with the medication's UUID.

### `ImagePicker.swift`
**Purpose:** A `UIViewControllerRepresentable` wrapper that bridges UIKit's `UIImagePickerController` to SwiftUI.
**Logic:**
* `makeUIViewController`: Configures the picker to allow image editing (cropping to square).
* `Coordinator`: Handles the delegate callbacks (`didFinishPickingMediaWithInfo`) to extract either the edited or original image and pass it back to the SwiftUI binding.

## 4. UI Views - Screens

### `ContentView.swift`
**Purpose:** The root view of the user interface.
**Key Components:**
* `TabView`: Manages navigation between the primary `MedicationListView` and the `HistoryView`.

### `MedicationListView.swift`
**Purpose:** The main dashboard displaying all saved medications.
**Key Components:**
* `@Query`: Fetches all `Medication` objects from SwiftData.
* `List`: Renders rows using `MedicationRowView`.
* `NavigationLink`: Navigates to the detail view.
* `.sheet`: Presents the `AddMedicationView` modally.
* `deleteMedication`: Handles swipe-to-delete actions by removing the object from the context.

### `AddMedicationView.swift`
**Purpose:** A form for creating new medication entries.
**Logic:**
* Uses local `@State` variables to capture user input.
* `MedicationImageButton`: Integrated to allow photo selection.
* `saveMedication()`:
    1.  Converts the selected `UIImage` to `Data`.
    2.  Initializes a new `Medication` object.
    3.  Inserts the object into the `modelContext`.
    4.  Immediately calls `NotificationManager` to schedule the reminder.

### `MedicationDetailView.swift`
**Purpose:** Allows viewing details, editing properties, managing status, and logging intake.
**Architecture - "Working Copy" Pattern:**
* On `onAppear`, data is loaded from the persistent `Medication` object into temporary `@State` variables.
* Changes are made to these state variables.
* `saveChanges()` writes the state back to the persistent object and updates the notification.
* `handleBackPress()`: Intercepts the navigation back action to warn the user if unsaved changes exist (`hasChanges` computed property).

**Key Functions:**
* `logIntake()`: Creates a new `IntakeLog`, appends it to the medication, triggers haptic feedback, and dismisses the view.
* `deleteMedication()`: Cancels the notification and deletes the object from the database.

### `HistoryView.swift`
**Purpose:** Displays a global list of all past intakes across all medications.
**Key Components:**
* `@Query(sort: \IntakeLog.date)`: Fetches `IntakeLog` objects directly, sorted by date in reverse order.
* `ContentUnavailableView`: Shown if the list is empty.
* **List Items:** Displays the medication name, dosage, and formatted timestamps.

## 5. UI Views - Components

### `MedicationRowView.swift`
**Purpose:** Defines the visual layout of a single row in the main list.
**Logic:**
* Displays name, dosage, and the computed schedule description.
* **Visual Status:** Checks `medication.isTakenToday`. If true, displays a green checkmark icon to indicate completion for the current day.

### `MedicationImageButton.swift`
**Purpose:** A reusable UI component for handling image selection logic.
**Logic:**
* Displays the selected image in a circular crop or a camera placeholder.
* `confirmationDialog`: Offers the user a choice between Camera, Gallery, or Delete Photo.
* `fullScreenCover`: Presents the `ImagePicker`.

***

# System Architecture Summary

The MedTracker application is built on a robust **MVVM-like architecture** leveraging SwiftUI's declarative nature and SwiftData's reactive persistence.

### 1. Data Flow & Persistence
The application uses a **Single Source of Truth**. The SwiftData `modelContext` manages the state.
* **Reading:** Views use `@Query` to fetch data. When data changes (e.g., a medication is edited), SwiftData automatically triggers UI updates.
* **Writing:** Changes are made within the `modelContext`. In `MedicationDetailView`, a buffer strategy is used (State variables) to prevent accidental edits, requiring an explicit "Save" action to commit changes to the context.

### 2. Notification Integration
The `NotificationManager` acts as a bridge between the data model and the system.
* **Synchronization:** The UI never talks to the `UNUserNotificationCenter` directly. Instead, when a medication is saved or edited, the view calls `NotificationManager.shared.scheduleNotification(for: medication)`.
* The manager uses the `medication.id` (UUID) as the notification identifier, ensuring that updating a schedule automatically replaces the old alert.

### 3. History & Relationships
The relationship between `Medication` and `IntakeLog` enables the "Mark as Done" feature.
* When a user logs an intake, a new `IntakeLog` is created.
* The `MedicationRowView` observes the medication. Its `isTakenToday` computed property checks the relationship. As soon as the log is added, the RowView redraws itself to show the green checkmark, providing immediate visual feedback to the user.
