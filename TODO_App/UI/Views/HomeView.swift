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

    @State private var shouldShowCreateTodoItemFullScreen = false
    @State private var todoItemEdit: TodoItem?

    @Query(
        filter: #Predicate<TodoItem> { todoItem in
            todoItem.isCompleted == false
        },
        sort: \.timestamp
    ) private var todoItems: [TodoItem]

    // MARK: - View

    var body: some View {
        NavigationStack {
            List {
                ForEach(todoItems) { item in
                    TodoItemRowView(item: item)
                        .swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    viewModel.deleteTodoItem(item, modelContext: modelContext)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .symbolVariant(.fill)
                            }

                            Button {
                                todoItemEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                }
            }
            .navigationTitle("My To Do List")
            .toolbar {
                ToolbarItem {
                    Button(
                        action: {
                            shouldShowCreateTodoItemFullScreen.toggle()
                        }, label: {
                            Label("Add item", systemImage: "plus")
                        }
                    )
                }
            }
            .fullScreenCover(
                isPresented: $shouldShowCreateTodoItemFullScreen,
                content: {
                    NavigationStack {
                        CreateTodoItemView()
                    }
                }
            )
            .fullScreenCover(item: $todoItemEdit) {
                todoItemEdit = nil
            } content: { todoItem in
                NavigationStack {
                    EditTodoItemView(todoItem: todoItem)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
