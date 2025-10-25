//
//  CreateTodoItemViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 21/10/25.
//

import SwiftUI
import SwiftData

class CreateTodoItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var title: String = ""
    @Published var timestamp: Date = .now
    @Published var isImportant: Bool = false

    @Injected private var logger: LoggerAPI

    // MARK: - Helpers

    func createTodoItem(modelContext: ModelContext) {
        let todoItem = TodoItem(
            title: title,
            timestamp: timestamp,
            isImportant: isImportant,
            isCompleted: false
        )

        modelContext.insert(todoItem)

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist creation: \(error)")
        }
    }
}
