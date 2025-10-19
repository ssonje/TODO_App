//
//  LoggerAPI.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

/// Abstraction over a logging facility.
///
/// Conforming types should route messages to the underlying logging
/// framework and may include call-site metadata such as file, function
/// and line for easier troubleshooting.
public protocol LoggerAPI {

    /// Logs a verbose-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path for the log entry.
    ///   - function: The function name where the log originated.
    ///   - line: The source line number for the log entry.
    func verbose(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int
    )

    /// Logs a debug-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path for the log entry.
    ///   - function: The function name where the log originated.
    ///   - line: The source line number for the log entry.
    func debug(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int
    )

    /// Logs an info-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path for the log entry.
    ///   - function: The function name where the log originated.
    ///   - line: The source line number for the log entry.
    func info(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int
    )

    /// Logs a warning-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path for the log entry.
    ///   - function: The function name where the log originated.
    ///   - line: The source line number for the log entry.
    func warning(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int
    )

    /// Logs an error-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path for the log entry.
    ///   - function: The function name where the log originated.
    ///   - line: The source line number for the log entry.
    func error(
        _ message: String,
        _ file: String,
        _ function: String,
        _ line: Int
    )
}

/// Convenience overloads that inject `#file`, `#function`, and `#line` defaults.
extension LoggerAPI {

    /// Logs a verbose-level message using default call-site metadata.
    func verbose(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        verbose(message, file, function, line)
    }

    /// Logs a debug-level message using default call-site metadata.
    func debug(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        debug(message, file, function, line)
    }

    /// Logs an info-level message using default call-site metadata.
    func info(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        info(message, file, function, line)
    }

    /// Logs a warning-level message using default call-site metadata.
    func warning(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        warning(message, file, function, line)
    }

    /// Logs an error-level message using default call-site metadata.
    func error(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        error(message, file, function, line)
    }
}
