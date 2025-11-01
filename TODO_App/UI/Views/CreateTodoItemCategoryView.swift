//
//  CreateTodoItemCategoryView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 23/10/25.
//

import SwiftData
import SwiftUI

struct CreateTodoItemCategoryView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel: CreateTodoItemCategoryViewModel

    @Query private var todoItemCategories: [TodoItemCategory]

    // MARK: - Init

    init(onSelect: ((TodoItemCategory?) -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: CreateTodoItemCategoryViewModel(onSelect: onSelect))
    }

    // MARK: - View

    var body: some View {
        List {
            titleSection
            categoriesSection
        }
        .navigationTitle("Add category")
    }

    // MARK: - View Builders

    @ViewBuilder
    private var titleSection: some View {
        Section("Title") {
            TextField("Enter category title", text: $viewModel.title)

            addCategoryButtonRow
        }
    }

    @ViewBuilder
    private var addCategoryButtonRow: some View {
        HStack {
            Spacer()

            Button("Add category") {
                withAnimation {
                    viewModel.createTodoCategory(modelContext: modelContext)
                }

                // If used as a selector, auto-dismiss after creating+selecting
                if viewModel.onSelect != nil {
                    dismiss()
                }
            }
            .disabled(viewModel.title.isEmpty)

            Spacer()
        }
    }

    @ViewBuilder
    private var categoriesSection: some View {
        Section("Categories") {
            if todoItemCategories.isEmpty == true {
                ContentUnavailableView(
                    "No categories are present",
                    systemImage: "archivebox"
                )
            } else {
                ForEach(todoItemCategories) { todoItemCategory in
                    HStack {
                        Text(todoItemCategory.title)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard let onSelect = viewModel.onSelect else { return }

                        onSelect(todoItemCategory)
                        dismiss()
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteTodoCategory(
                                    todoItemCategory: todoItemCategory,
                                    modelContext: modelContext
                                )
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }

                // Provide an explicit option to clear selection when used in selection mode
                if viewModel.onSelect != nil {
                    HStack {
                        Text("None")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.onSelect?(nil)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    return NavigationStack {
        CreateTodoItemCategoryView()
    }
}
