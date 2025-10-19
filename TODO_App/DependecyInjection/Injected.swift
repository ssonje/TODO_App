//
//  Injected.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

/// Property wrapper that resolves a dependency from the app's root DI container.
///
/// On initialization, the wrapper looks up `Dependency` in `rootContainer.container`.
/// If the dependency has not been registered, it triggers a runtime failure via `fatalError`.
///
/// Usage:
/// ```
/// @Injected var logger: LoggerAPI
/// ```
@propertyWrapper struct Injected<Dependency> {

    // MARK: - Properties

    /// The resolved dependency instance provided by the DI container.
    let wrappedValue: Dependency

    // MARK: - Initializer

    /// Creates the property wrapper by resolving `Dependency` from the root container.
    ///
    /// - Note: This will crash with `fatalError` if the dependency is not registered.
    init() {
        if let resolvedValue = rootContainer.container.resolve(Dependency.self) {
            self.wrappedValue = resolvedValue
        } else {
            fatalError("\(Dependency.self) dependency should be registered in the RootContainer")
        }
    }
}
