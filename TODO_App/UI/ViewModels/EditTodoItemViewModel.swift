//
//  EditTodoItemViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 21/10/25.
//

import SwiftUI
import SwiftData

final class EditTodoItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var title: String
    @Published var timestamp: Date
    @Published var isImportant: Bool
    @Published var isCompleted: Bool
    @Published var selectedTodoItemCategory: TodoItemCategory?

    @Injected private var logger: LoggerAPI

    // MARK: - Init

    init(item: TodoItem) {
        self.title = item.title
        self.timestamp = item.timestamp
        self.isImportant = item.isImportant
        self.isCompleted = item.isCompleted
        self.selectedTodoItemCategory = item.category
    }

    // MARK: - Helpers

    func editTodoItem(_ todoItem: TodoItem, modelContext: ModelContext) {
        todoItem.title = title
        todoItem.timestamp = timestamp
        todoItem.isImportant = isImportant
        todoItem.isCompleted = isCompleted
        todoItem.category = selectedTodoItemCategory

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist edited todo item: \(error)")
        }
    }
}
