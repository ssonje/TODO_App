//
//  HomeView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {

    // MARK: - Properties

    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = HomeViewModel()

    @Query(
        filter: #Predicate<TodoItem> { todoItem in
            todoItem.completed == false
        }
    ) private var todoItems: [TodoItem]

    private var filteredTodoItems: [TodoItem] {
        viewModel.getFilteredTodoItems(todoItems)
    }

    // MARK: - View

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            listContent
                .navigationTitle("My To Do List")
                .searchable(
                    text: $viewModel.searchQuery,
                    prompt: "Search todo items or categories"
                )
                .animation(.easeIn, value: filteredTodoItems)
                .overlay {
                    emptyStateOverlay
                }
                .overlay {
                    dimmingOverlay
                }
                .overlay(alignment: .bottomTrailing) {
                    floatingCreateMenu
                }
                .navigationDestination(for: HomeViewNavigationRoute.self) { route in
                    viewModel.navigateToDestination(route: route)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        sortingMenu
                    }
                }
                .task {
                    // Making this as commented because we don't wanted to fetch the initial records from server
                    // viewModel.fetchInitialTodosIfNeeded(modelContext: modelContext)
                }
        }
    }

    // MARK: - View Builders

    @ViewBuilder
    private var listContent: some View {
        List {
            ForEach(filteredTodoItems) { todoItem in
                TodoItemRowView(item: todoItem)
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteTodoItem(todoItem, modelContext: modelContext)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }

                        Button {
                            viewModel.onEditTodoItem(todoItem)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
            }
        }
    }

    @ViewBuilder
    private var emptyStateOverlay: some View {
        if filteredTodoItems.isEmpty {
            ContentUnavailableView.search
        }
    }

    @ViewBuilder
    private var dimmingOverlay: some View {
        if viewModel.showCreateMenu {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                        viewModel.showCreateMenu = false
                    }
                }
        }
    }

    @ViewBuilder
    private var floatingCreateMenu: some View {
        CreateTodoItemOrCategoryMenuView(
            isPresented: $viewModel.showCreateMenu,
            onCreateTodoItem: {
                viewModel.onCreateTodoItem()
            },
            onCreateCategory: {
                viewModel.onCreateCategory()
            }
        )
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var sortingMenu: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.sortField) {
                ForEach(SortField.allCases) { field in
                    Text(field.displayName).tag(field)
                }
            }

            Picker("Order", selection: $viewModel.isAscending) {
                Text("Ascending").tag(true)
                Text("Descending").tag(false)
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
