//
//  RootContainerMock.swift
//  TODO_AppTests
//
//  Created by Sanket Sonje on 19/10/25.
//

import Foundation
import Swinject

@testable import TODO_App

/// Helper to build a Swinject container configured with test doubles.
final class RootContainerMock {

    /// Builds and installs the test container into the app's global `rootContainer`.
    /// - Parameter overrides: Optional closure to override or add registrations before install.
    /// - Returns: The installed `Container`.
    @discardableResult
    static func install(overrides: ((Container) -> Void)? = nil) -> Container {
        let container = build()
        overrides?(container)
        rootContainer.container = container
        return container
    }

    /// Builds a container that wires test dependencies used by unit tests.
    /// - Returns: A configured `Container` instance.
    private static func build() -> Container {
        let container = Container()
        container.register(NetworkingSessionAPI.self) { _ in
            NetworkingSessionMock()
        }
        .inObjectScope(.container)

        container.register(LoggerAPI.self) { _ in
            LoggerMock()
        }
        .inObjectScope(.container)

        container.register(NetworkManagerAPI.self) { _ in
            NetworkManagerAPIImpl()
        }
        .inObjectScope(.container)

        return container
    }
}
