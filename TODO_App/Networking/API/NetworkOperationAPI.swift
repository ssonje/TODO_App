//
//  NetworkOperationAPI.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import Foundation

/// Abstraction that describes a single HTTP operation.
///
/// Conforming types specify the HTTP method, target path, headers, query parameters,
/// and an optional body. They can also build a configured `URLRequest` using these values.
///
/// - Important: For `GET` and `DELETE` requests, `data` is typically `nil` and
///   servers may ignore a request body. For `POST` and `PUT`, include a body when appropriate
///   and set `Content-Type` in `headers` (e.g., `application/json`).
public protocol NetworkOperationAPI {

    /// The HTTP method to use for the request (e.g., `GET`, `POST`, `PUT`, `DELETE`).
    var method: HttpMethod { get }

    /// The absolute or resolvable URL string representing the request path.
    var path: String { get }

    /// Additional header fields to include in the request.
    var headers: [String: String] { get }

    /// Query parameters to append to the URL.
    var queryItems: [String : String] { get }

    /// Optional request body. Commonly JSON-encoded data for `POST`/`PUT`.
    var data: Data? { get }

    /// Builds a `URLRequest` from the supplied properties.
    /// - Throws: `URLError(.badURL)` if the `path` cannot be converted to a valid URL.
    func makeURLRequest() throws -> URLRequest
}
