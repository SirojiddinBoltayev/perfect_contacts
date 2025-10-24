# Perfect Contacts Plugin

`perfect_contacts` is a Flutter plugin designed to fetch device contacts in a clean, scalable, and maintainable way using **Clean Architecture**. It provides a stream-based API to retrieve contacts and handles permissions gracefully, making it suitable for large-scale Flutter applications.

## Table of Contents
- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Example App](#example-app)
- [File Structure](#file-structure)
- [Dependencies](#dependencies)
- [Platform Setup](#platform-setup)
  - [Android](#android)
  - [iOS](#ios)
- [Error Handling](#error-handling)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Features
- **Clean Architecture**: Organized into domain, data, and core layers for separation of concerns, testability, and scalability.
- **Custom Either**: Robust error handling with a lightweight, custom `Either`.
- **Stream-Based API**: Provides a `Stream<ContactState>` to handle asynchronous contact fetching with loading, success, and error states.
- **Permission Handling**: Integrates with `permission_handler` to request and manage contact permissions.
- **Platform-Agnostic**: Works seamlessly on Android and iOS via Flutter's MethodChannel.
- **Example App**: Includes a fully functional example app demonstrating how to use the plugin in a real Flutter project.

## Architecture
The plugin follows **Clean Architecture** principles, ensuring a clear separation of concerns. The codebase is divided into three main layers:

1. **Domain Layer**:
   - Contains business logic, entities (`Contact`), repository interfaces (`ContactRepository`), and use cases (`GetContactsUseCase`).
   - Independent of Flutter or external systems, making it highly testable and reusable.

2. **Data Layer**:
   - Handles data operations, including serialization (`ContactModel`), repository implementation (`ContactRepositoryImpl`), and native platform communication (`ContactMethodChannel`).
   - Maps domain entities to platform-specific data models.

3. **Core Layer**:
   - Includes shared utilities like the custom `Either` class, enums (`ContactStateStatus`), error handling (`Failure`), and state management (`ContactState`).

This structure ensures the plugin is maintainable, scalable, and adheres to SOLID principles.

## Installation
To use the `perfect_contacts` plugin in your Flutter project, follow these steps:

1. Add the plugin to your `pubspec.yaml`:
   ```yaml
   dependencies:
     perfect_contacts:
       path: path/to/perfect_contacts
     permission_handler: ^11.0.0
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure platform-specific permissions (see [Platform Setup](#platform-setup)).

## Usage

### Basic Usage
The plugin provides a `PerfectContactsPlugin` class with a `contactsStream` that emits `ContactState` objects. The `ContactState` includes the status (`idle`, `loading`, `success`, `error`), a list of contacts, and an optional error message.

```dart
import 'package:flutter/material.dart';
import 'package:perfect_contacts/perfect_contacts_plugin.dart';
import 'package:perfect_contacts/core/enums/contact_state_status.dart';
import 'package:perfect_contacts/core/state/contact_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ContactsScreen(),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: StreamBuilder<ContactState>(
        stream: PerfectContactsPlugin().contactsStream,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state == null || state.status == ContactStateStatus.idle) {
            return const Center(child: Text('Waiting to start...'));
          }

          switch (state.status) {
            case ContactStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ContactStateStatus.error:
              return Center(child: Text(state.errorMessage ?? 'An error occurred'));
            case ContactStateStatus.success:
              final contacts = state.contacts;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    title: Text(contact.fullName),
                    subtitle: Text('${contact.phoneNumber} (${contact.countryCode})'),
                  );
                },
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
```

### Example App
The plugin includes an example app located in the `example` folder. To run it:

1. Navigate to the `example` directory:
   ```bash
   cd example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

The example app displays a list of contacts with a modern UI, including loading states, error messages, and a card-based layout for each contact.

## File Structure
The plugin is organized as follows:

```
perfect_contacts/
├── lib/
│   ├── core/
│   │   ├── either/
│   │   │   └── either.dart           # Custom Either class for error handling
│   │   ├── enums/
│   │   │   └── contact_state_status.dart  # Enum for contact fetching states
│   │   ├── error/
│   │   │   └── failures.dart         # Failure classes for error handling
│   │   └── state/
│   │       └── contact_state.dart    # State class for contact stream
│   ├── domain/
│   │   ├── entities/
│   │   │   └── contact.dart          # Contact entity
│   │   ├── repositories/
│   │   │   └── contact_repository.dart  # Repository interface
│   │   ├── usecases/
│   │   │   └── get_contacts_usecase.dart  # Use case for fetching contacts
│   ├── data/
│   │   ├── models/
│   │   │   └── contact_model.dart    # Contact model with serialization
│   │   ├── repositories/
│   │   │   └── contact_repository_impl.dart  # Repository implementation
│   │   ├── sources/
│   │   │   └── contact_method_channel.dart  # Native platform communication
│   └── perfect_contacts_plugin.dart  # Main plugin entry point
├── example/
│   ├── lib/
│   │   └── main.dart                 # Example app
│   └── pubspec.yaml                  # Example app dependencies
└── pubspec.yaml                      # Plugin dependencies
```

## Dependencies
The plugin requires the following dependencies in the `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.0.0
```

The example app additionally depends on the `perfect_contacts` plugin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  perfect_contacts:
    path: ../
  permission_handler: ^11.0.0
```


## Platform Setup

### Android
Add the following permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_CONTACTS"/>
```

Ensure the `android` section in the plugin's `pubspec.yaml` is configured:

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.perfect_contacts
        pluginClass: PerfectContactsPlugin
```

### iOS
Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSContactsUsageDescription</key>
<string>We need access to your contacts to display them in the app.</string>
```

Ensure the `ios` section in the plugin's `pubspec.yaml` is configured:

```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: PerfectContactsPlugin
```

## Error Handling
The plugin uses a custom `Either` class to handle errors gracefully. The `Either` class supports two states:
- **Left**: Represents a failure (e.g., `PermissionDeniedFailure`, `ContactFetchFailure`).
- **Right**: Represents a successful result (e.g., `List<Contact>`).

Errors are propagated through the `ContactState` stream with appropriate error messages. Common errors include:
- **PermissionDeniedFailure**: Triggered when the user denies contact access.
- **ContactFetchFailure**: Triggered for platform or network-related errors.

Example of handling errors in the UI:

```dart
if (state.status == ContactStateStatus.error) {
  return Center(child: Text(state.errorMessage ?? 'An error occurred'));
}
```

## Testing
The Clean Architecture structure makes the plugin highly testable. Key components to test include:

- **GetContactsUseCase**: Mock the `ContactRepository` to test business logic.
- **ContactRepositoryImpl**: Mock the `ContactMethodChannel` to simulate native platform responses.
- **ContactModel**: Test JSON serialization and deserialization.

To set up tests, create a `test` directory and use a testing framework like `flutter_test`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:perfect_contacts/core/either/either.dart';

void main() {
  test('GetContactsUseCase returns contacts', () async {
    // Mock repository and test use case
  });
}
```

The custom `Either` class simplifies mocking by avoiding external dependencies.

## Contributing
Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

Please ensure your code follows Clean Architecture and includes tests for new features.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.