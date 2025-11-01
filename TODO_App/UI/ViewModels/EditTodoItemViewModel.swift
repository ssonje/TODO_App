//
//  EditTodoItemViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 21/10/25.
//

import SwiftUI
import Foundation
import SwiftData

final class EditTodoItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var title: String {
        didSet {
            if shouldDisplayTitleError && title.isEmpty == false {
                shouldDisplayTitleError = false
            }
        }
    }
    @Published var shouldDisplayTitleError: Bool = false

    @Published var completed: Bool
    @Published var timestamp: Date
    @Published var isImportant: Bool
    @Published var selectedTodoItemCategory: TodoItemCategory?
    @Published var pushCreateCategory: Bool = false

    @Injected private var logger: LoggerAPI
    @Injected private var networkManagerAPI: NetworkManagerAPI

    // MARK: - Init

    init(item: TodoItem) {
        self.title = item.title
        self.completed = item.completed
        self.timestamp = item.timestamp ?? .now
        self.isImportant = item.isImportant ?? false
        self.selectedTodoItemCategory = item.category
    }

    // MARK: - Helpers

    func editTodoItem(_ todoItem: TodoItem, modelContext: ModelContext) -> Bool {
        guard title.isEmpty == false else {
            shouldDisplayTitleError = true
            return false
        }

        return persistLocalEditFromViewModel(todoItem, modelContext: modelContext)

        // Do not perform edit request
        /*
             performEditTodoRequest(for: todoItem) { [weak self] (result: Result<TodoItem, Error>) in
             guard let self else { return }

                 switch result {
                 case .success(let responseItem):
                    self.persistLocalEdit(todoItem, with: responseItem, modelContext: modelContext)
                 case .failure(let error):
                    self.logger.error("Failed to edit todo on server: \(error.localizedDescription)")
                 }
             }
         */
    }

    // MARK: - Private Helpers

    private func performEditTodoRequest(for todoItem: TodoItem, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        do {
            let requestBody = TodoItem(
                id: todoItem.id,
                userId: todoItem.userId,
                title: title,
                completed: completed
            )
            let data = try JSONEncoder().encode(requestBody)
            let operation: NetworkOperationAPI = NetworkOperationAPIImpl(
                method: .put,
                path: "https://jsonplaceholder.typicode.com/todos/\(todoItem.id)",
                headers: [:],
                queryItems: [:],
                data: data
            )
            let request = try operation.makeURLRequest()
            networkManagerAPI.executeRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func persistLocalEdit(_ todoItem: TodoItem, with responseItem: TodoItem, modelContext: ModelContext) {
        todoItem.title = responseItem.title
        todoItem.completed = responseItem.completed
        todoItem.userId = responseItem.userId
        todoItem.timestamp = timestamp
        todoItem.isImportant = isImportant
        todoItem.category = selectedTodoItemCategory

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist edited todo item: \(error)")
        }
    }

    private func persistLocalEditFromViewModel(
        _ todoItem: TodoItem,
        modelContext: ModelContext
    ) -> Bool {
        todoItem.title = title
        todoItem.completed = completed
        todoItem.timestamp = timestamp
        todoItem.isImportant = isImportant
        todoItem.category = selectedTodoItemCategory

        do {
            try modelContext.save()
            return true
        } catch {
            logger.error("Failed to persist edited todo item: \(error)")
            return false
        }
    }
}
