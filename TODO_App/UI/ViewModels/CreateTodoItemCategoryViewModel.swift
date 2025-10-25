//
//  CreateTodoItemCategoryViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 23/10/25.
//

import SwiftUI
import SwiftData

class CreateTodoItemCategoryViewModel: ObservableObject {

    // MARK: - Properties

    @Published var title: String = ""

    @Injected private var logger: LoggerAPI

    // MARK: - Helpers

    func createTodoCategory(modelContext: ModelContext) {
        let todoItemCategory = TodoItemCategory(title: title)
        modelContext.insert(todoItemCategory)
        todoItemCategory.todoItems = []
        title = ""

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist creation: \(error)")
        }
    }

    func deleteTodoCategory(
        todoItemCategory: TodoItemCategory,
        modelContext: ModelContext
    ) {
        modelContext.delete(todoItemCategory)

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist delete: \(error)")
        }
    }
}
