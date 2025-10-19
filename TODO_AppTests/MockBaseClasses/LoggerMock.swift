//
//  LoggerMock.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import Foundation

@testable import TODO_App

/// Lightweight test double for `LoggerAPI` used in unit tests.
///
/// Captures info and error messages in memory so tests can assert on
/// what the system under test attempted to log without emitting output.
final class LoggerMock: LoggerAPI {

    func verbose(_ message: String, _ file: String, _ function: String, _ line: Int) { }
    func debug(_ message: String, _ file: String, _ function: String, _ line: Int) { }
    func info(_ message: String, _ file: String, _ function: String, _ line: Int) { }
    func warning(_ message: String, _ file: String, _ function: String, _ line: Int) { }
    func error(_ message: String, _ file: String, _ function: String, _ line: Int) { }
}
