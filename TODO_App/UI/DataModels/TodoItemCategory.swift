//
//  TodoItemCategory.swift
//  TODO_App
//
//  Created by Sanket Sonje on 23/10/25.
//

import SwiftData
import SwiftUI

@Model
public final class TodoItemCategory {

    // MARK: - Properties

    @Attribute(.unique)
    public var title: String

    public var todoItems: [TodoItem]?

    // MARK: - Initializer

    public init(title: String = "") {
        self.title = title
    }
}
