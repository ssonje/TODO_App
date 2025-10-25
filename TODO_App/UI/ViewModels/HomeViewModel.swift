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
        if searchQuery.isEmpty == true {
            return todoItems
        }

        return todoItems.compactMap { todoItem in
            return (
                todoItem.title.lowercased().contains(searchQuery.lowercased())
                || (todoItem.category?.title.lowercased().contains(searchQuery.lowercased()) == true)
            )
                ? todoItem
                : nil
        }
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
}
