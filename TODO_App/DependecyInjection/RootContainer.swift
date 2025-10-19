//
//  RootContainer.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Foundation
import Swinject

/// Owner for the application's dependency injection container.
///
/// Lazily builds a `Swinject.Container` on first access and exposes it via
/// the `container` property. Create and retain an instance at app startup
/// (e.g., in `TODO_AppApp`) and pass it where needed to register and resolve
/// dependencies.
final class RootContainer {

    // MARK: - Properties

    /// Public accessor for the DI container.
    ///
    /// If the container has not been built yet, it will be created via `buildContainer()`.
    /// If for some reason the container is still `nil`, a `fatalError` is raised.
    var container: Container {
        get {
            if _container == nil {
                _container = buildContainer()
            }

            if let container = _container {
                return container
            }

            fatalError("Root container is not initialized")
        }

        set {
            _container = newValue
        }
    }

    /// Backing storage for the DI container.
    private var _container: Container?

    // MARK: - Private Helpers

    /// Builds and configures the DI container with all required services.
    ///
    /// - Returns: A configured `Container` instance with app-wide registrations.
    private func buildContainer() -> Container {
        let container = Container()

        // Inject networking session dependency
        container.register(NetworkingSessionAPI.self) { _ in
            return NetworkingSessionAPIImpl()
        }

        // Inject network manager dependency
        container.register(NetworkManagerAPI.self) { _ in
            return NetworkManagerAPIImpl()
        }

        // Inject logging dependency
        container.register(LoggerAPI.self) { _ in
            return LoggerAPIImpl()
        }
        .inObjectScope(.container)

        return container
    }
}
