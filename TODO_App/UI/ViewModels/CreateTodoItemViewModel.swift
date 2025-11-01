//
//  CreateTodoItemViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 21/10/25.
//

import SwiftUI
import Foundation
import SwiftData

class CreateTodoItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var title: String = ""
    @Published var timestamp: Date = .now
    @Published var isImportant: Bool = false
    @Published var pushCreateCategory: Bool = false
    @Published var selectedTodoItemCategory: TodoItemCategory?

    @Injected private var logger: LoggerAPI
    @Injected private var networkManagerAPI: NetworkManagerAPI

    // MARK: - Helpers

    func createTodoItem(
        selectedTodoItemCategory: TodoItemCategory?,
        modelContext: ModelContext
    ) {
        let todoItem = TodoItem(
            id: 0,
            userId: 1,
            title: title,
            completed: false,
            timestamp: timestamp,
            isImportant: isImportant
        )
        persistLocalCreation(
            from: todoItem,
            selectedCategory: selectedTodoItemCategory,
            modelContext: modelContext
        )

        // Do not perform delete request
        /*
            performCreateTodoRequest { [weak self] (result: Result<TodoItem, Error>) in
                guard let self else { return }

                switch result {
                case .success(let todoItem):
                    self.persistLocalCreation(from: todoItem, selectedCategory: selectedTodoItemCategory, modelContext: modelContext)
                case .failure(let error):
                    self.logger.info(error.localizedDescription)
                }
            }
         */
    }

    // MARK: - Private Helpers

    private func performCreateTodoRequest(completion: @escaping (Result<TodoItem, Error>) -> Void) {
        do {
            let requestBody = TodoItem(
                id: 0,
                userId: 1,
                title: title,
                completed: false
            )
            let data = try JSONEncoder().encode(requestBody)
            let operation: NetworkOperationAPI = NetworkOperationAPIImpl(
                method: .post,
                path: "https://jsonplaceholder.typicode.com/todos",
                headers: [:],
                queryItems: [:],
                data: data
            )
            let request = try operation.makeURLRequest()
            networkManagerAPI.executeRequest(request, completion: completion)
        } catch {
            logger.info(error.localizedDescription)
            completion(.failure(error))
        }
    }

    private func persistLocalCreation(from todoItem: TodoItem, selectedCategory: TodoItemCategory?, modelContext: ModelContext) {
        modelContext.insert(todoItem)

        todoItem.category = selectedCategory
        selectedCategory?.todoItems?.append(todoItem)

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to save created TodoItem: \(error)")
        }
    }
}
