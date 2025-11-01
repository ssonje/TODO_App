//
//  TodoItemView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 26/10/25.
//

import SwiftUI
import SwiftData

struct TodoItemView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: TodoItemViewModel

    // MARK: - Initializer

    init(
        item: TodoItem,
        onTap: @escaping (TodoItem) -> Void,
    ) {
        _viewModel = StateObject(
            wrappedValue: TodoItemViewModel(
                item: item,
                onTap: onTap
            )
        )
    }

    // MARK: - View

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.item.title)
                    .style(.title)

                if let category = viewModel.item.category?.title, !category.isEmpty {
                    Text(category)
                        .style(.subtitle)
                }

                HStack(spacing: 8) {
                    if viewModel.isDueSoon {
                        TodoItemCategoryView(title: "Due Soon", color: .red)
                    }

                    if let isImportant = viewModel.item.isImportant, isImportant {
                        TodoItemCategoryView(title: "High", color: .red)
                    }
                }
            }

            Spacer()

            completionCheckbox
        }
        .onTapGesture {
            viewModel.handleTap()
        }
        .swipeActions {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteItem(modelContext: modelContext)
                }
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .card(padding: 24)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var completionCheckbox: some View {
        Button {
            viewModel.toggleCompleted(modelContext: modelContext)
        } label: {
            Image(systemName: viewModel.item.completed ? "checkmark.square.fill" : "square")
                .font(.title3)
                .foregroundStyle(viewModel.item.completed ? .green : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(viewModel.item.completed ? "Mark as not completed" : "Mark as completed")
    }
}

// MARK: - Preview

#Preview {
    List {
        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "Pay for utility services",
                    completed: false,
                    timestamp: .now,
                    isImportant: true
                )
                item.category = TodoItemCategory(title: "Home")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "Buy groceries",
                    completed: true,
                    timestamp: .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "This is my very very very long todo item",
                    completed: false,
                    timestamp: .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "This is my very very very very very very very very very very long todo item",
                    completed: false,
                    timestamp: .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "This is my very very very very very very very very very very long todo item",
                    completed: true,
                    timestamp: .now,
                    isImportant: true
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "Pay for utility services",
                    completed: false,
                    timestamp: Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now,
                    isImportant: true
                )
                item.category = TodoItemCategory(title: "Home")
                return item
            }(),
            onTap: { _ in }
        )

        TodoItemView(
            item: {
                let item = TodoItem(
                    title: "Buy groceries",
                    completed: true,
                    timestamp: Calendar.current.date(byAdding: .hour, value: 2, to: .now) ?? .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }(),
            onTap: { _ in }
        )
    }
    .background(Color(.systemGroupedBackground))
}
