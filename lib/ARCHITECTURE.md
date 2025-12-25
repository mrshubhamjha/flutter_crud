# Project Architecture

This project follows a **Feature-Based Clean Architecture** pattern, which organizes code by features rather than by technical layers.

## Folder Structure

```
lib/
├── core/                    # Shared utilities and infrastructure
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error handling classes
│   ├── network/            # Network configuration, interceptors
│   ├── theme/              # App themes, colors, text styles
│   └── utils/              # Helper functions, extensions
│
├── shared/                 # Shared across multiple features
│   ├── widgets/            # Reusable widgets
│   └── models/             # Shared data models
│
└── features/               # Feature modules
    └── login/              # Login feature (example)
        ├── data/           # Data layer
        │   ├── datasources/    # API calls, local storage
        │   ├── models/         # Data models (JSON serialization)
        │   └── repositories/   # Repository implementations
        │
        ├── domain/         # Domain layer (business logic)
        │   ├── entities/       # Pure business objects
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/      # Business logic use cases
        │
        └── presentation/   # Presentation layer (UI)
            ├── bloc/          # BLoC/Cubit for state management
            ├── pages/         # Full page screens
            └── widgets/       # Feature-specific widgets
```

## Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Pure Dart classes representing business objects
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-purpose business logic operations
- **No dependencies** on Flutter or external frameworks

### 2. **Data Layer** (Data Sources)
- **Data Sources**: API calls, local database, shared preferences
- **Models**: Data transfer objects with JSON serialization
- **Repository Implementations**: Concrete implementations of domain repositories
- **Depends on**: Domain layer

### 3. **Presentation Layer** (UI)
- **BLoC/Cubit**: State management
- **Pages**: Full screen widgets
- **Widgets**: Reusable UI components for the feature
- **Depends on**: Domain layer (uses use cases and entities)

## Dependency Flow

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies (pure business logic)

## Adding a New Feature

To add a new feature (e.g., `todos`):

1. Create the feature folder: `lib/features/todos/`
2. Create the three layers: `data/`, `domain/`, `presentation/`
3. Follow the same structure as the `login` feature
4. Implement:
   - Domain entities and use cases first
   - Data sources and repository implementations
   - Presentation BLoC and UI

## Example: Login Feature

### Domain
- `entities/user.dart` - User entity
- `repositories/auth_repository.dart` - Repository interface
- `usecases/login_usecase.dart` - Login business logic

### Data
- `models/user_model.dart` - User data model with JSON
- `datasources/auth_remote_datasource.dart` - API calls
- `repositories/auth_repository_impl.dart` - Repository implementation

### Presentation
- `bloc/login_bloc.dart` - State management
- `pages/login_page.dart` - Login screen UI

## Benefits

1. **Scalability**: Easy to add new features without affecting others
2. **Testability**: Each layer can be tested independently
3. **Maintainability**: Clear separation of concerns
4. **Team Collaboration**: Different developers can work on different features
5. **Reusability**: Domain logic can be reused across platforms

