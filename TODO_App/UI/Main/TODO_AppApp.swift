//
//  TODO_AppApp.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import SwiftUI

// MARK: - Global Properties

/// Root dependency injection container instance for the application.
///
/// Created at app launch and used to register and resolve dependencies
/// throughout the app's lifetime. Prefer passing this instance into
/// features that require it rather than creating additional containers.
let rootContainer = RootContainer()

// MARK: - Main

@main
struct TODO_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
