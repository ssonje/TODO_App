//
//  NetworkManagerAPIImpl.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Concrete implementation of `NetworkManagerAPI` backed by `URLSession`.
///
/// - Uses dependency injection to obtain a `NetworkingSessionAPI` (source of truth for `URLSession`) and a `LoggerAPI`.
/// - Executes any HTTP method encapsulated by a configured `URLRequest`.
/// - Decodes JSON responses into the caller-specified `Decodable` type `T`.
/// - Delivers the completion handler on the main queue.
class NetworkManagerAPIImpl: NetworkManagerAPI {

    // MARK: - Properties

    /// Shared networking session provider injected via DI.
    @Injected private var networkingSession: NetworkingSessionAPI

    /// Logger used for recording success and error events.
    @Injected private var logger: LoggerAPI

    // MARK: - Initializer

    /// Creates a new instance of the network manager.
    init() { }

    // MARK: - NetworkManagerAPI

    /// Executes a configured request and decodes the JSON response into the provided `Decodable` type.
    /// - Parameters:
    ///   - request: The configured `URLRequest` to execute (includes method, url, headers, body).
    ///   - completion: Completion handler called on the main queue with a `Result` containing the decoded value or an error.
    /// - Important: Ensure the generic `T` matches the JSON structure returned by the endpoint (e.g., use `[Todo]` for an array of todos).
    /// - Note: Network and decoding errors are forwarded via the `.failure` case.
    func executeRequest<T>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        // Create URL Session to fetch data
        let dataTask = networkingSession.session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self else { return }

            if let error {
                self.logger.error("Network request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard response is HTTPURLResponse else {
                self.logger.error("Nil response from the server. Unable to parse as HTTPURLResponse")
                return
            }

            guard let data else {
                self.logger.error("Nil data received from the server")
                return
            }

            do {
                // Parse the data
                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    self.logger.info("Request executed and data decoded successfully")
                }
            } catch {
                self.logger.error("Failed to decode the response body: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
        }

        dataTask.resume()
    }
}
