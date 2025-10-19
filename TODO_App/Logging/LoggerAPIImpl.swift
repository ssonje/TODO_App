//
//  LoggerAPIImpl.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import SwiftyBeaver

/// Concrete logger backed by SwiftyBeaver.
///
/// Configures a console destination and exposes convenience methods
/// for common log levels. Each method records the originating file,
/// function and line number for easier debugging.
class LoggerAPIImpl: LoggerAPI {

    // MARK: - Properties

    private static let sharedLogger: SwiftyBeaver.Type = {
        let logger = SwiftyBeaver.self
        let console = ConsoleDestination()
        logger.addDestination(console)
        return logger
    }()

    private let logger: SwiftyBeaver.Type = LoggerAPIImpl.sharedLogger

    // MARK: - Functions

    /// Logs a verbose-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path. Defaults to the current file.
    ///   - function: The function name. Defaults to the current function.
    ///   - line: The line number. Defaults to the current line.
    func verbose(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        logger.verbose(message, file: file, function: function, line: line)
    }

    /// Logs a debug-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path. Defaults to the current file.
    ///   - function: The function name. Defaults to the current function.
    ///   - line: The line number. Defaults to the current line.
    func debug(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        logger.debug(message, file: file, function: function, line: line)
    }

    /// Logs an info-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path. Defaults to the current file.
    ///   - function: The function name. Defaults to the current function.
    ///   - line: The line number. Defaults to the current line.
    func info(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        logger.info(message, file: file, function: function, line: line)
    }

    /// Logs a warning-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path. Defaults to the current file.
    ///   - function: The function name. Defaults to the current function.
    ///   - line: The line number. Defaults to the current line.
    func warning(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        logger.warning(message, file: file, function: function, line: line)
    }

    /// Logs an error-level message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - file: The source file path. Defaults to the current file.
    ///   - function: The function name. Defaults to the current function.
    ///   - line: The line number. Defaults to the current line.
    func error(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line
    ) {
        logger.error(message, file: file, function: function, line: line)
    }
}
