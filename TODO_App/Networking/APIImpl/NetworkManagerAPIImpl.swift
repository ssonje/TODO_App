//
//  NetworkManagerAPIImpl.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Concrete implementation of `NetworkManagerAPI` that performs GET requests using `URLSession`.
/// - Uses dependency injection to obtain a `NetworkingSessionAPI` (source of truth for `URLSession`) and a `LoggerAPI`.
/// - Decodes JSON responses into the caller-specified `Decodable` type.
/// - Dispatches the completion handler on the main queue.
class NetworkManagerAPIImpl: NetworkManagerAPI {

    // MARK: - Properties

    /// Shared networking session provider injected via DI.
    @Injected private var networkingSession: NetworkingSessionAPI

    /// Logger used for recording success and error events.
    @Injected private var logger: LoggerAPI

    // MARK: - Initializer

    /// Creates a new instance of the network manager.
    init() { }

    // MARK: - Fetch Data

    /// Fetches JSON data from a URL and decodes it into the provided `Decodable` type.
    /// - Parameters:
    ///   - url: The endpoint to request.
    ///   - completion: Completion handler called on the main queue with a `Result` containing the decoded value or an error.
    /// - Important: Ensure the generic `T` matches the JSON structure returned by the endpoint (e.g., use `[Todo]` for a top-level array of todos).
    /// - Note: Network and decoding errors are forwarded via the `.failure` case.
    func fetchData<T>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        // Create URL Session to fetch data
        let dataTask = networkingSession.session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self else { return }

            if let error {
                self.logger.error("Unfortunately, get request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard response is HTTPURLResponse else {
                self.logger.error("Get nil response from the server. Hence, Unable to parse the response as HTTPURLResponse")
                return
            }

            guard let data else {
                self.logger.error("Get nil data from the server")
                return
            }

            do {
                // Parse the data
                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    self.logger.info("Data fetched successfully")
                }
            } catch {
                self.logger.error("Failed to decode the data")
                completion(.failure(error))
                return
            }
        }

        dataTask.resume()
    }
}
