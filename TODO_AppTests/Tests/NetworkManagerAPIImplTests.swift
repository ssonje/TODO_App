//
//  NetworkManagerAPIImplTests.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Testing
import Foundation
import Swinject

@testable import TODO_App

@Suite(.serialized)
struct NetworkManagerAPIImplTests: BaseUnitTestCase {

    // MARK: - Tests

    @Test
    func fetchData_success_decodesTodos() async throws {
        // Given
        let todosJSON = try #require("""
        [
            {
                "userId":1,
                "id":1,
                "title":"A",
                "completed":false
            },
            {
                "userId":1,
                "id":2,
                "title":"B",
                "completed":true
            }
        ]
        """.data(using: .utf8))
        let url = try #require(URL(string: "https://jsonplaceholder.test.typicode.com/todos"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let stubbedSession = URLProtocolMock.makeStubbedSession(
            data: todosJSON,
            response: response,
            error: nil
        )

        let testRootContainer = RootContainerMock.install()
        testRootContainer.register(NetworkingSessionAPI.self) { _ in
            NetworkingSessionMock(session: stubbedSession)
        }
        .inObjectScope(.container)

        // When
        let sut: NetworkManagerAPI = NetworkManagerAPIImpl()
        let result: Result<[Todo], Error> = await withCheckedContinuation { continuation in
            sut.fetchData(from: url) { (result: Result<[Todo], Error>) in
                continuation.resume(returning: result)
            }
        }

        // Then
        switch result {
        case .success(let todos):
            #expect(todos.count == 2)
        case .failure(let error):
            Issue.record("Unexpected failure: \(error)")
        }
    }

    @Test
    func fetchData_failure_decodingError() async throws {
        // Given
        let badJSON = try #require("""
        {
            "unexpected":"shape"
        }
        """.data(using: .utf8))
        let url = try #require(URL(string: "https://jsonplaceholder.test.typicode.com/todos"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let stubbedSession = URLProtocolMock.makeStubbedSession(
            data: badJSON,
            response: response,
            error: nil
        )

        let testRootContainer = RootContainerMock.install()
        testRootContainer.register(NetworkingSessionAPI.self) { _ in
            NetworkingSessionMock(session: stubbedSession)
        }
        .inObjectScope(.container)

        // When
        let sut: NetworkManagerAPI = NetworkManagerAPIImpl()
        let result: Result<[Todo], Error> = await withCheckedContinuation { continuation in
            sut.fetchData(from: url) { (result: Result<[Todo], Error>) in
                continuation.resume(returning: result)
            }
        }

        // Then
        switch result {
        case .success:
            Issue.record("Expected failure")
        case .failure:
            #expect(true)
        }
    }

    @Test
    func fetchData_failure_networkError() async throws {
        // Given
        enum Dummy: Error { case boom }
        let url = try #require(URL(string: "https://jsonplaceholder.test.typicode.com/todos"))
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let stubbedSession = URLProtocolMock.makeStubbedSession(
            data: nil,
            response: response,
            error: Dummy.boom
        )

        let testRootContainer = RootContainerMock.install()
        testRootContainer.register(NetworkingSessionAPI.self) { _ in
            NetworkingSessionMock(session: stubbedSession)
        }
        .inObjectScope(.container)

        // When
        let sut: NetworkManagerAPI = NetworkManagerAPIImpl()
        let result: Result<[Todo], Error> = await withCheckedContinuation { continuation in
            sut.fetchData(from: url) { (result: Result<[Todo], Error>) in
                continuation.resume(returning: result)
            }
        }

        // Then
        switch result {
        case .success:
            Issue.record("Expected failure")
        case .failure:
            #expect(true)
        }
    }
}
