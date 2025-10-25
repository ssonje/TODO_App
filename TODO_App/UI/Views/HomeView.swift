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
            todoItem.isCompleted == false
        },
        sort: \.timestamp
    ) private var todoItems: [TodoItem]

    // MARK: - View

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                ForEach(todoItems) { todoItem in
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
            .navigationTitle("My To Do List")
            
            .overlay {
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
            .overlay(alignment: .bottomTrailing) {
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
            .navigationDestination(for: HomeViewNavigationRoute.self) { route in
                viewModel.navigateToDestination(route: route)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
