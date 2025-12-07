# MedTracker

[cite_start]MedTracker is a native iOS application designed to help users track their medication schedules and ensure timely intake through local notifications[cite: 1, 2].

## Project Overview

This project is developed as part of the Mobile Development course. [cite_start]The primary goal is to create a functional application that allows users to manage their medication inventory locally on the device and receive reminders without requiring an internet connection[cite: 4, 10].

## Features

The application implements the following core functionalities:

* [cite_start]**Medication Management:** Users can add, edit, and delete medication entries[cite: 6].
* [cite_start]**Scheduling:** Users can define recurring schedules for their medication[cite: 7].
* [cite_start]**Reminders:** The app utilizes local push notifications to remind users when it is time to take their medication[cite: 8].
* [cite_start]**Intake Tracking:** Users can mark a scheduled intake as completed[cite: 9].
* [cite_start]**Status Control:** Ability to pause (deactivate) or resume specific medications[cite: 18, 23].

## Technology Stack

The project relies on the modern iOS development stack suggested by the course curriculum:

* **Language:** Swift
* [cite_start]**User Interface:** SwiftUI [cite: 3]
* [cite_start]**Data Persistence:** SwiftData [cite: 3, 11]
* [cite_start]**Notifications:** UserNotifications Framework [cite: 3]
* **IDE:** Xcode

## Data Model

The application uses SwiftData for persistence. [cite_start]The core entity is **Medication**, which includes the following properties[cite: 12]:
* `id`: Unique identifier
* `name`: Name of the medication
* `dosage`: Dosage information
* `notes`: Additional instructions or notes
* `isActive`: Boolean status to toggle reminders

## Project Structure

[cite_start]The codebase is organized into the following logical components[cite: 15, 16, 17, 18]:

* **App:** The entry point of the application setting up the SwiftData container.
* **Models:** Contains the `Medication` and `IntakeLog` data definitions.
* **Views:**
    * `MedListView`: The main dashboard displaying the list of all medications.
    * `AddMedicationView` / `EditMedicationView`: Forms for inputting data.
    * `MedicationDetailView`: A detailed view allowing users to read notes and pause medication.

## Setup and Requirements

1.  Clone this repository.
2.  Open the project file in Xcode.
3.  Ensure the deployment target is set to the latest iOS version.
4.  Build and run the application on the iPhone Simulator or a physical device.

[cite_start]**Note:** When running on a device, you must grant permission for the application to send notifications when prompted[cite: 8, 22].



