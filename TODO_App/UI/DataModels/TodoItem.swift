//
//  TodoItem.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import Foundation
import SwiftData

@Model
public final class TodoItem {

    // MARK: - Properties

    public var title: String
    public var timestamp: Date
    public var isImportant: Bool
    public var isCompleted: Bool

    // MARK: - Initializer

    public init(
        title: String = "",
        timestamp: Date = .now,
        isImportant: Bool = false,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.timestamp = timestamp
        self.isImportant = isImportant
        self.isCompleted = isCompleted
    }
}
