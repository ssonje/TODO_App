//
//  URLProtocolMock.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Foundation

/// URLProtocol subclass that stubs network requests for unit tests.
///
/// Configure a response via `URLProtocolMock.stub` or create a
/// preconfigured `URLSession` using `URLProtocolMock.makeStubbedSession(...)`.
final class URLProtocolMock: URLProtocol {

    /// The currently configured stub. When set, requests intercepted by this
    /// protocol will replay the provided `response`, `data` and/or `error`.
    static var stub: Stub?

    // MARK: - URLProtocol overrides

    /// Determines whether this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    /// Returns the canonical form of the given request (no-op for tests).
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    /// Starts loading by replaying the configured stubbed response.
    override func startLoading() {
        if let response = URLProtocolMock.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = URLProtocolMock.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = URLProtocolMock.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    /// Required override; nothing to clean up for stubbed responses.
    override func stopLoading() { }

    // MARK: - Stub

    /// Container describing a single stubbed response to return to the client.
    struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    // MARK: - Test Helper

    /// Creates a `URLSession` configured to use `URLProtocolMock` and sets
    /// the stub that will be replayed by the protocol.
    ///
    /// - Parameters:
    ///   - data: The data to return to the client.
    ///   - response: The `URLResponse` to send before data.
    ///   - error: The error to complete with (if non-nil, takes precedence).
    /// - Returns: An ephemeral `URLSession` wired to `URLProtocolMock`.
    static func makeStubbedSession(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> URLSession {
        URLProtocolMock.stub = Stub(data: data, response: response, error: error)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }
}
