//
//  NetworkManagerAPI.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Abstraction over executing HTTP requests and decoding responses.
///
/// Conforming types execute a configured `URLRequest` (supporting any HTTP method)
/// and decode the HTTP response body into the caller-specified `Decodable` type.
/// Implementations may choose how to schedule completion delivery (e.g., main queue).
public protocol NetworkManagerAPI {
    
    /// Executes the provided request and decodes the JSON response into type `T`.
    /// - Parameters:
    ///   - request: A fully configured `URLRequest` to execute (method, url, headers, body).
    ///   - completion: Called with a `Result` containing the decoded value or an error.
    /// - Important: Ensure `T` reflects the response schema (e.g., `[Todo]` for arrays).
    /// - Note: Implementations should document the thread on which `completion` is invoked.
    func executeRequest<T>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable

}
