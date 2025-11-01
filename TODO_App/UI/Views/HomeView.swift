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
            ForEach(filteredTodoItems, id: \.persistentModelID) { todoItem in
                TodoItemView(
                    item: todoItem,
                    onTap: { item in
                        viewModel.onEditTodoItem(item)
                    }
                )
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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
        Button {
            viewModel.onCreateTodoItem()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(
                    Circle().fill(Color.accentColor)
                )
                .shadow(radius: 4)
        }
        .padding(.trailing, 32)
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
