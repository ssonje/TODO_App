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

    // MARK: - Helpers

    func deleteTodoItem(_ todoItem: TodoItem, modelContext: ModelContext) {
        modelContext.delete(todoItem)

        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to persist delete: \(error)")
        }
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

    private func sortTodoItems(_ todoItems: [TodoItem]) -> [TodoItem] {
        let sortedTodoItems: [TodoItem]
        switch sortField {
        case .todoTitle:
            sortedTodoItems = todoItems.sorted { $0.title < $1.title }
        case .date:
            sortedTodoItems = todoItems.sorted { $0.timestamp < $1.timestamp }
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
