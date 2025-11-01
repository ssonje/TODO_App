//
//  TodoItem.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import Foundation
import SwiftData

@Model
public final class TodoItem: Codable {

    // MARK: - Properties

    // Making this commented as we are not using any API
    // @Attribute(.unique)
    public var id: Int
    public var userId: Int
    public var title: String
    public var completed: Bool

    public var timestamp: Date?
    public var isImportant: Bool?

    @Relationship(deleteRule: .nullify, inverse: \TodoItemCategory.todoItems)
    public var category: TodoItemCategory?

    // MARK: - Initializer

    public init(
        id: Int = 0,
        userId: Int = 0,
        title: String = "",
        completed: Bool = false,
        timestamp: Date = .now,
        isImportant: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.completed = completed
        self.timestamp = timestamp
        self.isImportant = isImportant
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.completed = try container.decode(Bool.self, forKey: .completed)

        // Local-only defaults (not provided by API)
        self.timestamp = .now
        self.isImportant = false
        self.category = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(completed, forKey: .completed)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case completed
    }
}
