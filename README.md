### TODO App (SwiftUI)

SwiftUI learning project showcasing a simple TODO flow with clean architecture principles: dependency injection, a thin networking layer, structured logging, and unit tests with stubs/mocks.

---

### Features

- **SwiftUI app scaffold**: `TODO_AppApp` launches `ContentView` with a basic UI and an `ObservableObject` view model.
- **Dependency Injection via Swinject**:
  - Central `RootContainer` builds and exposes a `Swinject.Container` at app start.
  - Custom `@Injected` property wrapper resolves dependencies from the root container.
  - Registrations for `NetworkingSessionAPI`, `NetworkManagerAPI`, and `LoggerAPI`.
- **Networking layer**:
  - `NetworkingSessionAPI` abstraction and a default `NetworkingSessionAPIImpl` using `URLSession.shared`.
  - `NetworkManagerAPI` protocol with a generic `fetchData(from:completion:)`.
  - `NetworkManagerAPIImpl` performs GET requests and decodes JSON into any `Decodable` type, returning results on the main queue.
  - `NetworkingAPIConstants` centralizes base URL (`https://jsonplaceholder.typicode.com/`).
- **Structured logging**:
  - `LoggerAPI` protocol defines `verbose`, `debug`, `info`, `warning`, `error`.
  - `LoggerAPIImpl` uses SwiftyBeaver with a console destination.
- **Example usage in UI**:
  - `TestViewModel` fetches todos from JSONPlaceholder and logs results on `onAppear()` of `ContentView`.
- **Unit tests with stubs/mocks**:
  - `URLProtocolMock` for stubbing network responses.
  - `NetworkingSessionMock` to inject a custom `URLSession` in tests.
  - `LoggerMock` no-op logger for tests.
  - `RootContainerMock` installs a test DI container with overrides.
  - Tests for `NetworkManagerAPIImpl` cover success, decoding failure, and network error paths.

---

### Project Structure

```text
TODO_App/
  TODO_App/
    DependecyInjection/
      Injected.swift
      RootContainer.swift
    Logging/
      LoggerAPI.swift
      LoggerAPIImpl.swift
    Networking/
      API/
        NetworkManagerAPI.swift
      APIImpl/
        NetworkManagerAPIImpl.swift
      Base/Session/
        NetworkingSessionAPI.swift
        NetworkingSessionAPIImpl.swift
      Utils/
        NetworkingAPIConstants.swift
    ContentView.swift
    TestViewModel.swift
    TODO_AppApp.swift
  TODO_AppTests/
    MockBaseClasses/
      LoggerMock.swift
      NetworkingSessionMock.swift
      RootContainerMock.swift
      URLProtocolMock.swift
    Tests/
      NetworkManagerAPIImplTests.swift
```

---

### Dependencies

- **Swinject**: Dependency Injection container
- **SwiftyBeaver**: Logging

Managed via Swift Package Manager (see `TODO_App.xcodeproj` workspace `Package.resolved`).

---

### Setup & Run

1. Open the workspace/project in Xcode 16 (or compatible Xcode with Swift 5.10+).
2. Ensure SPM resolves `Swinject` and `SwiftyBeaver` automatically.
3. Build and run the `TODO_App` scheme on iOS Simulator or device.

---

### Testing

1. Select the `TODO_AppTests` scheme.
2. Run tests (⌘U). Tests verify the networking layer using stubbed sessions:
   - Successful decode of `[Todo]`
   - Decoding failure path
   - Network error path

---

### Notes

- The current UI intentionally stays minimal; the focus is on a clean, testable foundation (DI + Networking + Logging).
- Extend `NetworkManagerAPI` with more HTTP verbs, headers, and request building as needed.
- Add persistence and richer SwiftUI views incrementally on top of this base.


