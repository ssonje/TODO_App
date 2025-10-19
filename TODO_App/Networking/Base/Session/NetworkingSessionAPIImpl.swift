//
//  NetworkingSessionAPIImpl.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Default implementation of `NetworkingSessionAPI` that exposes a shared `URLSession`.
/// - Acts as the single source of truth for the app's networking session.
class NetworkingSessionAPIImpl: NetworkingSessionAPI {

    var session: URLSession

    // MARK: - Initializer

    /// Initializes the networking session with `URLSession.shared`.
    init() {
        session = URLSession.shared
    }
}
