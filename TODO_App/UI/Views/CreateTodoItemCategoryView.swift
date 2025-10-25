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

    @StateObject var viewModel = CreateTodoItemCategoryViewModel()

    @Query private var todoItemCategories: [TodoItemCategory]

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
                    Text(todoItemCategory.title)
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
