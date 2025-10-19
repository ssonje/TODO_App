//
//  BaseUnitTestCase.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Swinject

/// Protocol for Swift Testing suites that require a test-configured DI container.
/// Conforming types get a default implementation that installs the container.
protocol BaseUnitTestCase {

    /// Reference to the test DI container installed into the global `rootContainer`.
    var testRootContainer: Container { get }
}

extension BaseUnitTestCase {
    /// Default container factory.
    var testRootContainer: Container { RootContainerMock.install() }
}
