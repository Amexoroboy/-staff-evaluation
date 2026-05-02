# Staff Evaluation Application

## Project Description
A Flutter application designed to manage and evaluate staff members. It fetches staff data from a public API, allows users to perform evaluations, saves them locally, and uses device features like Location.

## Features
- **Fetch Staff Data**: Integration with JSONPlaceholder API to retrieve staff details.
- **Staff Evaluation Form**: Stateful form with input validation and slider for scoring.
- **Local Storage**: Uses `shared_preferences` to persist evaluation history.
- **Location Integration**: Uses `geolocator` to fetch and display the user's current coordinates.
- **Navigation**: Structured navigation between Dashboard, List, Form, and History screens.
- **Responsive UI**: Built using Row, Column, GridView, and Expanded widgets.

## Group Members
- [Hayu Abdusemed] - [ID 0536/15]
- [Ahmedin Remedan] - [0109/15]
- [Abdulhakim kemal   - [19578/15]
- [Lensa Kedir] - [2907/15]
- [Mehadi Abduselam] - [05/15]

## Video Link (Loom)
[Inshttps://www.loom.com/share/586f132911a34d32a31c8a3716a92877ert Loom Video Link Here]

## Use Case Trace: Save Evaluation
1. **User Interaction**: The user fills the comments field and selects a score, then clicks the "Save Evaluation" button. (Handled by `onPressed` in `evaluation_form_screen.dart`).
2. **UI Response**: A `LoadingIndicator` can be shown (implicit during async ops), and upon success, an `AlertDialog` is displayed to provide feedback.
3. **Logic Execution**: `_submitForm()` method is triggered, which validates the form using `_formKey.currentState!.validate()`.
4. **Data Processing**: A Map object containing `staffId`, `score`, `comments`, and `date` is created.
5. **Storage Action**: The `StorageService.saveEvaluation()` method is called, which encodes the map to JSON and saves it to `SharedPreferences`.
6. **Final Result**: The `AlertDialog` confirms success, and the user is navigated back to the previous screen using `Navigator.pop()`.
