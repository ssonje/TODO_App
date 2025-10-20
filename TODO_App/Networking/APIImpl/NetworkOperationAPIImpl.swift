//
//  NetworkOperationAPIImpl.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import Foundation

/// Default implementation of `NetworkOperationAPI` that builds `URLRequest`s.
///
/// - Applies provided headers and query parameters.
/// - Sets the HTTP body only for methods that typically include one (`POST`, `PUT`).
/// - Adds a default `Accept: application/json` header when not explicitly provided.
/// - Throws an error instead of terminating the app when the URL cannot be formed.
public class NetworkOperationAPIImpl: NetworkOperationAPI {

    // MARK: - Properties

    /// The HTTP method to use for the request.
    public var method: HttpMethod

    /// The absolute or resolvable URL string representing the request path.
    public var path: String

    /// Additional header fields to include in the request.
    public var headers: [String : String]

    /// Query parameters to append to the URL.
    public var queryItems: [String : String]

    /// Optional request body. Commonly JSON-encoded data for `POST`/`PUT`.
    public var data: Data?

    /// Logger used for recording success and error events.
    @Injected private var logger: LoggerAPI

    // MARK: - Initializer

    /// Creates a new network operation with the provided components.
    /// - Parameters:
    ///   - method: The HTTP method to use.
    ///   - path: The absolute or resolvable URL string.
    ///   - headers: Additional header fields to include in the request.
    ///   - queryItems: Query parameters to append to the URL.
    ///   - data: Optional request body for methods like `POST`/`PUT`.
    init(
        method: HttpMethod,
        path: String,
        headers: [String : String],
        queryItems: [String : String],
        data: Data?
    ) {
        self.method = method
        self.path = path
        self.headers = headers
        self.queryItems = queryItems
        self.data = data
    }

    // MARK: - NetworkOperationAPI

    /// Builds a `URLRequest` using the operation's properties.
    /// - Throws: `URLError(.badURL)` if the `path` cannot be converted to a valid URL.
    public func makeURLRequest() throws -> URLRequest {
        var components = URLComponents(string: path)
        if queryItems.isEmpty == false {
            components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components?.url else {
            self.logger.error("Given \(path) url is bad url")
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        switch method {
        case .post, .put:
            request.httpBody = data
            if data != nil, request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        case .get, .delete:
            break
        }

        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

        return request
    }
}
