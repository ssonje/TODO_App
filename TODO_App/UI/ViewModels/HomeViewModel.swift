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

    @Published var showCreateMenu = false
    @Published var path = NavigationPath()
    @Published var searchQuery = ""
    @Published var sortField: SortField = .date
    @Published var isAscending: Bool = false

    @Injected private var logger: LoggerAPI
    @Injected private var networkManagerAPI: NetworkManagerAPI

    // MARK: - Helpers

    func deleteTodoItem(_ todoItem: TodoItem, modelContext: ModelContext) {
        persistLocalDeletion(of: todoItem, in: modelContext, todoId: todoItem.id)

        // Do not perform delete request
        /*
            let todoId = todoItem.id
            performDeleteTodoRequest(todoId: todoId) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success:
                    self.persistLocalDeletion(of: todoItem, in: modelContext, todoId: todoId)
                case .failure(let error):
                    self.logger.error("Failed to delete todo id=\(todoId) on server: \(error.localizedDescription)")
                }
            }
        */
    }

    func onCreateTodoItem() {
        path.append(HomeViewNavigationRoute.createTodoItem)
    }

    func onCreateCategory() {
        path.append(HomeViewNavigationRoute.createTodoItemCategory)
    }

    func onEditTodoItem(_ todoItem: TodoItem) {
        path.append(HomeViewNavigationRoute.editTodoItem(todoItem: todoItem))
    }

    func fetchInitialTodosIfNeeded(modelContext: ModelContext) {
        let hasFetchedKey = "initialTodosFetched"
        let defaults = UserDefaults.standard

        if defaults.bool(forKey: hasFetchedKey) {
            return
        }

        do {
            let operation: NetworkOperationAPI = NetworkOperationAPIImpl(
                method: .get,
                path: "https://jsonplaceholder.typicode.com/todos",
                headers: [:],
                queryItems: [:],
                data: nil
            )
            let request = try operation.makeURLRequest()
            networkManagerAPI.executeRequest(request, completion: { [weak self] (result: Result<[TodoItem], Error>) in
                guard let self else { return }

                switch result {
                case .success(let todoItems):
                    todoItems.forEach { modelContext.insert($0) }

                    do {
                        try modelContext.save()
                        defaults.set(true, forKey: hasFetchedKey)
                        self.logger.info("Initial todos fetched and saved successfully")
                    } catch {
                        self.logger.error("Failed to persist fetched todos: \(error)")
                    }

                case .failure(let error):
                    self.logger.error("Initial fetch failed: \(error.localizedDescription)")
                }
            })
        } catch {
            logger.error(error.localizedDescription)
        }
    }

    func getFilteredTodoItems(_ todoItems: [TodoItem]) -> [TodoItem] {
        let filteredTodoItems: [TodoItem]

        if searchQuery.isEmpty == true {
            filteredTodoItems = todoItems
        } else {
            filteredTodoItems = todoItems.compactMap { todoItem in
                (
                    todoItem.title.lowercased().contains(searchQuery.lowercased())
                    || (todoItem.category?.title.lowercased().contains(searchQuery.lowercased()) == true)
                )
                ? todoItem
                : nil
            }
        }

        return sortTodoItems(filteredTodoItems)
    }

    @ViewBuilder
    func navigateToDestination(route: HomeViewNavigationRoute) -> some View {
        switch route {
        case .createTodoItem:
            CreateTodoItemView()
        case .createTodoItemCategory:
            CreateTodoItemCategoryView()
        case let .editTodoItem(todoItem: todoItem):
            EditTodoItemView(todoItem: todoItem)
        }
    }

    // MARK: - Private Helpers

    private func performDeleteTodoRequest(todoId: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        do {
            let operation: NetworkOperationAPI = NetworkOperationAPIImpl(
                method: .delete,
                path: "https://jsonplaceholder.typicode.com/todos/\(todoId)",
                headers: [:],
                queryItems: [:],
                data: nil
            )
            let request = try operation.makeURLRequest()
            networkManagerAPI.executeRequest(request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    private func persistLocalDeletion(of todoItem: TodoItem, in modelContext: ModelContext, todoId: Int) {
        modelContext.delete(todoItem)
        do {
            try modelContext.save()
            logger.info("Successfully deleted todo id=\(todoId) on server")
        } catch {
            logger.error("Failed to persist delete: \(error)")
        }
    }

    private func sortTodoItems(_ todoItems: [TodoItem]) -> [TodoItem] {
        let sortedTodoItems: [TodoItem]
        switch sortField {
        case .todoTitle:
            sortedTodoItems = todoItems.sorted { $0.title < $1.title }

        case .date:
            sortedTodoItems = todoItems.sorted(by: {
                guard let firstTimestamp = $0.timestamp,
                      let secondTimestamp = $1.timestamp else {
                    return false
                }

                return firstTimestamp < secondTimestamp
            })

        case .categoryTitle:
            sortedTodoItems = todoItems.sorted(by: {
                guard let firstCategoryTitle = $0.category?.title,
                      let secondCategoryTitle = $1.category?.title else {
                    return false
                }

                return firstCategoryTitle < secondCategoryTitle
            })
        }

        return isAscending ? sortedTodoItems : Array(sortedTodoItems.reversed())
    }
}
