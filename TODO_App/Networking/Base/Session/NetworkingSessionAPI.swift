//
//  NetworkingSessionAPI.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Abstraction that provides access to a `URLSession` used for network requests.
/// - Conforming types should act as the source of truth for the app's `URLSession`.
public protocol NetworkingSessionAPI {

    // MARK: - Properties

    /// The `URLSession` instance used to perform network requests.
    var session: URLSession { get }
}
