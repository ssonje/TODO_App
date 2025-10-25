//
//  HttpMethod.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import Foundation

/// Represents the supported HTTP methods for network requests.
///
/// - Note: The raw value matches the exact uppercase string expected by `URLRequest.httpMethod`.
public enum HttpMethod: String, RawRepresentable {

    /// HTTP GET method. Typically used to retrieve data; body is generally not sent.
    case get = "GET"

    /// HTTP POST method. Typically used to create resources; body is commonly included.
    case post = "POST"

    /// HTTP DELETE method. Typically used to delete resources; body is generally not sent.
    case delete = "DELETE"

    /// HTTP PUT method. Typically used to fully replace a resource; body is commonly included.
    case put = "PUT"

}
