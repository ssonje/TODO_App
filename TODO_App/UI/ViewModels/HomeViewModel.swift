//
//  HomeViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 23/10/25.
//

import SwiftData
import SwiftUI

final class HomeViewModel: ObservableObject {

    // MARK: - Properties

    @Injected private var logger: LoggerAPI

    // MARK: - Helpers

    func deleteTodoItem(_ todoItem: TodoItem, modelContext: ModelContext) {
        modelContext.delete(todoItem)

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist delete: \(error)")
        }
    }
}
