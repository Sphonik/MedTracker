# MedTracker

[cite_start][cite: 1]MedTracker is a native iOS application designed to help users track their medication schedules and ensure timely intake through local notifications.

## Project Overview

[cite_start]This project was developed as part of the Mobile Development course. [cite: 4][cite_start]The primary goal is to create a fully functional application that allows users to manage their medication inventory locally on the device and receive reminders without requiring an internet connection. [cite: 10]The app emphasizes data privacy by keeping all user data stored locally on the device.

## Key Features

The application implements the following core functionalities:

* [cite_start]**Medication Management:** Users can create, edit, and delete medication entries[cite: 6].
* **Visual Identification:** Users can attach photos to medications using the camera or photo gallery for easier identification.
* [cite_start]**Flexible Scheduling:** Support for various frequencies including daily, weekly, monthly, and interval-based (every X days) schedules[cite: 7].
* [cite_start]**Smart Reminders:** The app utilizes the `UserNotifications` framework to schedule precise local alerts based on the user's defined frequency[cite: 3, 8].
* [cite_start]**Intake Tracking:** Users can mark a medication as taken directly from the list or detail view, creating a permanent history log[cite: 9, 14].
* [cite_start]**History & Overview:** A detail view provides a history of past intakes and allows users to pause (deactivate) specific reminders without deleting the medication[cite: 18, 23].

## Technology Stack

The project relies on a modern iOS development stack:

* **Language:** Swift
* [cite_start]**User Interface:** SwiftUI (MVVM pattern) [cite: 3]
* [cite_start]**Data Persistence:** SwiftData [cite: 3, 11]
* [cite_start]**Notifications:** UserNotifications Framework [cite: 3]
* **Media:** UIKit Integration (`UIImagePickerController` via `UIViewControllerRepresentable`)
* **IDE:** Xcode

## Application Architecture

The project follows Clean Code principles and is structured to separate concerns effectively:

* **App:** Contains the `MedTrackerApp` entry point and ModelContainer setup.
* **Models:** Defines the SwiftData entities:
    * [cite_start]`Medication`: The primary entity containing details, schedule configuration, and image data[cite: 12].
    * [cite_start]`IntakeLog`: Represents a timestamped record of a completed intake[cite: 14].
* **Views:**
    * [cite_start]**Screens:** Standalone views such as `MedicationListView`, `AddMedicationView`, and `MedicationDetailView`[cite: 16, 17, 18].
    * **Components:** Reusable UI elements like `MedicationRowView` and `MedicationImageButton`.
* **Managers:** Contains the singleton `NotificationManager` which handles authorization, scheduling logic, and cancellation of local notifications.
* **Helpers:** Utility extensions and wrappers, including the `ImagePicker` for camera access.

## Data Model

The application uses a relational SwiftData model:

### [cite_start]Medication [cite: 12]
* `id`: UUID
* `name`: String
* `dosage`: String
* `notes`: String
* `isActive`: Bool
* `reminderTime`: Date
* `frequency`: Enum (Daily, Weekly, Monthly, EveryXDays)
* `interval`: Int
* `imageData`: Data (External Storage)
* `logs`: [IntakeLog] (One-to-Many Relationship)

### [cite_start]IntakeLog [cite: 14]
* `date`: Date
* `medication`: Medication (Inverse Relationship)

## Setup and Installation

1.  **Clone the repository:**
    Download the source code to your local machine.
2.  **Open in Xcode:**
    Open the `.xcodeproj` file.
3.  **Check Permissions:**
    The `Info.plist` includes keys for Camera and Photo Library usage (`Privacy - Camera Usage Description`).
4.  **Build and Run:**
    Select a simulator or a physical device.

**Important Note for Testing:**
[cite_start][cite: 22]To receive notifications in the Simulator, lock the screen (Cmd + L) or return to the Home Screen (Cmd + Shift + H) after scheduling a medication. The camera feature requires a physical device; on the Simulator, please use the Gallery option.

## User Stories Implemented

[cite_start]* [cite: 21]As a user, I can save medications to be reminded.
[cite_start]* [cite: 22]As a user, I receive notifications at the intake time.
[cite_start]* [cite: 23]As a user, I can pause or activate medications.
[cite_start]* [cite: 24]As a user, I see an overview of my entries.
