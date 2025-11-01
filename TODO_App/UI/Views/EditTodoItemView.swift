//
//  EditTodoItemView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import SwiftData
import SwiftUI

struct EditTodoItemView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel: EditTodoItemViewModel

    @Query private var todoItemCategories: [TodoItemCategory]

    var todoItem: TodoItem

    // MARK: - Init

    init(todoItem: TodoItem) {
        self.todoItem = todoItem
        _viewModel = StateObject(wrappedValue: EditTodoItemViewModel(item: todoItem))
    }

    // MARK: - View

    var body: some View {
        List {
            nameSection

            detailsSection

            categorySection

            editButtonSection
        }
        .navigationTitle("Edit todo")
    }

    // MARK: - View Builders

    @ViewBuilder
    private var nameSection: some View {
        Section("Name") {
            TextField("Name", text: $viewModel.title)
        }
    }

    @ViewBuilder
    private var detailsSection: some View {
        Section("Details") {
            DatePicker(
                "Choose a date",
                selection: $viewModel.timestamp
            )

            Toggle("Important?", isOn: $viewModel.isImportant)
        }
    }

    @ViewBuilder
    private var categorySection: some View {
        Section("Choose a category") {
            if todoItemCategories.isEmpty == true {
                ContentUnavailableView(
                    "No categories are present",
                    systemImage: "archivebox"
                )
            } else {
                Picker("", selection: $viewModel.selectedTodoItemCategory) {
                    ForEach(todoItemCategories) { todoItemCategory in
                        Text(todoItemCategory.title)
                            .tag(todoItemCategory as TodoItemCategory?)
                    }

                    Text("None")
                        .tag(nil as TodoItemCategory?)
                }
                .labelsHidden()
                .pickerStyle(.inline)
            }
        }
    }

    @ViewBuilder
    private var editButtonSection: some View {
        Section {
            HStack {
                Spacer()

                Button("Edit todo") {
                    withAnimation {
                        viewModel.editTodoItem(todoItem, modelContext: modelContext)
                    }
                    dismiss()
                }

                Spacer()
            }
        }
    }
}

// MARK: - Preview

#Preview {

    let todoItem = TodoItem(
        title: "Read a book",
        completed: false,
        timestamp: .now,
        isImportant: false
    )

    return NavigationStack {
        EditTodoItemView(todoItem: todoItem)
    }
    .modelContainer(for: TodoItem.self)
}
