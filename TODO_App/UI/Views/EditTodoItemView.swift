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
        .navigationDestination(isPresented: $viewModel.pushCreateCategory) {
            CreateTodoItemCategoryView { selected in
                viewModel.selectedTodoItemCategory = selected
            }
        }
    }

    // MARK: - View Builders

    @ViewBuilder
    private var nameSection: some View {
        Section("Title") {
            TextField("Todo Item Title", text: $viewModel.title)

            if viewModel.shouldDisplayTitleError {
                Text("Todo item title should be non empty")
                    .style(.tag(color: .red))
            }
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
                HStack(spacing: 8) {
                    Image(systemName: "archivebox")
                        .foregroundStyle(.secondary)
                    Text("No categories yet")
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                createCategoryButton
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
                .pickerStyle(.navigationLink)

                createCategoryButton
            }
        }
    }

    @ViewBuilder
    private var editButtonSection: some View {
        Section {
            HStack {
                Spacer()

                Button {
                    withAnimation {
                        if viewModel.editTodoItem(todoItem, modelContext: modelContext) {
                            dismiss()
                        }
                    }
                } label: {
                    Label(
                        "Edit Todo",
                        systemImage: "pencil.line"
                    )
                }

                Spacer()
            }
        }
    }

    @ViewBuilder
    private var createCategoryButton: some View {
        HStack {
            Spacer()

            Button {
                viewModel.pushCreateCategory = true
            } label: {
                Label(
                    todoItemCategories.isEmpty == true ? "Create category" : "Add category",
                    systemImage: "plus.circle"
                )
            }

            Spacer()
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
