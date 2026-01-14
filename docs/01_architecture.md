# Architecture

## Overview

This project follows **Clean Architecture** principles with a **feature-first** organization. This structure promotes separation of concerns, testability, and scalability.

## Clean Architecture Layers

### Domain Layer
- **Entities**: Pure business objects with no dependencies
- **Repositories**: Abstract interfaces defining data contracts
- **Use Cases**: Business logic operations

### Data Layer
- **Models/DTOs**: Data Transfer Objects with serialization
- **Data Sources**: Remote and local data sources
- **Repository Implementations**: Concrete implementations of domain repositories

### Presentation Layer
- **Cubits/Blocs**: State management
- **Screens**: UI components
- **Widgets**: Reusable UI components

## Feature-First Structure

Features are organized by domain functionality rather than by layer:

```
features/
  auth/
    data/
    domain/
    presentation/
  feed/
    data/
    domain/
    presentation/
```

### Benefits
- **Co-location**: Related code is grouped together
- **Modularity**: Features can be easily extracted into packages
- **Scalability**: Easy to add new features without affecting others
- **Team Collaboration**: Teams can work on different features independently

## Core Infrastructure

Shared infrastructure lives in `core/`:

- **config/**: Environment configuration
- **di/**: Dependency injection setup
- **network/**: HTTP client and interceptors
- **storage/**: Storage abstractions
- **logging/**: Logging utilities
- **utils/**: Shared utilities (Result, pagination, validators)
- **analytics/**: Analytics service interface

## Dependency Flow

```
Presentation → Domain ← Data
     ↓            ↑
   Core Infrastructure
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies (pure Dart)
- Core provides shared infrastructure

## Modularization Guidance

### When to Extract a Feature Module

Consider extracting a feature to a separate package when:
- Feature is large and self-contained
- Feature has minimal dependencies on other features
- Feature needs independent versioning
- Multiple teams work on different features

### Module Structure

```
feature_module/
  lib/
    feature_module.dart  # Public API
    src/
      data/
      domain/
      presentation/
  test/
  pubspec.yaml
```

## Caching Strategy

### Network Caching
- Use Dio interceptors for HTTP caching
- Implement cache headers parsing
- Store cache in memory or local storage

### Local Caching
- Use `LocalStorage` abstraction for key-value storage
- Consider `flutter_secure_storage` for sensitive data
- Implement cache invalidation strategies

### Best Practices
- Cache API responses when appropriate
- Implement TTL (Time To Live) for cached data
- Clear cache on logout or app reset
- Use cache for offline support

## State Management

### Cubit vs Bloc

- **Cubit**: Use for simple state flows (most cases)
- **Bloc**: Use when you need event transformation or complex event handling

### State Design

- States are immutable (using freezed)
- Each state represents a distinct UI state
- Side effects (navigation, toasts) handled via BlocListener

## Error Handling

- Domain layer uses `Result<T>` for type-safe error handling
- Network errors mapped to domain exceptions
- UI shows user-friendly error messages
- Errors logged with context (request-id, stack trace)

## Testing Strategy

- **Unit Tests**: Domain logic, utilities, mappers
- **Bloc Tests**: State transitions and business logic
- **Repository Tests**: Data layer with mocked data sources
- **Integration Tests**: End-to-end user flows
