//
//  NetworkingSessionMock.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Foundation
import Swinject

@testable import TODO_App

/// Test implementation of `NetworkingSessionAPI`.
///
/// Exposes a `URLSession` used by the app's networking layer during tests.
/// Defaults to `URLSession.shared`, but can be swapped by other helpers if needed.
final class NetworkingSessionMock: NetworkingSessionAPI {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
