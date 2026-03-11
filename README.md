# Taghyeer Task

A Flutter application demonstrating Clean Architecture with BLoC state management. The app fetches and displays products and posts from remote APIs, with local caching and user authentication.


### [⬇️ Download APK](https://github.com/Tanjid470/taghyeer_task/releases/download/release/app-release.apk)


## Features

- **User Authentication** - Login/logout functionality with local caching
- **Products & Posts** - Fetch and display products and posts from REST APIs
- **Caching** - Local storage using SharedPreferences for offline access
- **Theme Support** - Dynamic theme switching capability
- **Image Caching** - Efficient image loading and caching with cached_network_image
- **Clean Architecture** - Organized into Domain, Data, and Presentation layers

## Architecture

The project follows Clean Architecture principles:

- **Domain Layer** - Business logic, entities, repository interfaces, and use cases
- **Data Layer** - Repository implementations, data sources (local/remote), and models
- **Presentation Layer** - UI screens, widgets, and state management using BLoC

## Tech Stack

- **Framework** - Flutter 3.9.2+
- **State Management** - Flutter BLoC 9.1.1
- **HTTP Client** - http 1.3.0
- **Local Storage** - SharedPreferences 2.5.3
- **Image Handling** - cached_network_image 3.4.1
- **Utilities** - equatable 2.0.5

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.9.2 or higher

### Installation

1. Clone the repository and navigate to the project directory
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── core/              # Core functionality (constants, errors, networking, theme)
├── data/              # Data layer (datasources, models, repositories)
├── domain/            # Domain layer (entities, repositories, usecases)
└── presentation/      # UI layer (screens, widgets, BLoC)
    ├── auth/          # Authentication screens and logic
    ├── home/          # Home screen
    ├── posts/         # Posts display
    ├── products/      # Products display
    ├── settings/      # Settings and theme customization
    └── widgets/       # Reusable UI components
```
