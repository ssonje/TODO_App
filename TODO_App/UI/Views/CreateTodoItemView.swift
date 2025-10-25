//
//  CreateTodoItemView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import SwiftData
import SwiftUI

struct CreateTodoItemView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTodoItemCategory: TodoItemCategory?
    @StateObject var viewModel = CreateTodoItemViewModel()

    @Query private var todoItemCategories: [TodoItemCategory]

    // MARK: - View

    var body: some View {
        List {
            titleSection

            detailsSection

            categorySection

            createButtonSection
        }
        .navigationTitle("Create todo")
    }

    // MARK: - View Builders

    @ViewBuilder
    private var titleSection: some View {
        Section("Title") {
            TextField("Todo Item Title", text: $viewModel.title)
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
                Picker("", selection: $selectedTodoItemCategory) {
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
    private var createButtonSection: some View {
        Section {
            HStack {
                Spacer()

                Button("Create todo") {
                    withAnimation {
                        viewModel.createTodoItem(
                            selectedTodoItemCategory: selectedTodoItemCategory,
                            modelContext: modelContext
                        )
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
    return NavigationStack {
        CreateTodoItemView()
    }
    .modelContainer(for: TodoItem.self)
}
