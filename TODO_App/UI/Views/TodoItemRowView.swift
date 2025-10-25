//
//  TodoItemRowView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import SwiftData
import SwiftUI

struct TodoItemRowView: View {

    // MARK: - Properties

    private var item: TodoItem

    // MARK: - Initializer

    init(item: TodoItem) {
        self.item = item
    }

    // MARK: - View

    var body: some View {
        HStack {
            leftContent

            Spacer()

            completeButton
        }
        .padding()
    }

    // MARK: - View Builders

    @ViewBuilder
    private var leftContent: some View {
        VStack(alignment: .leading) {
            importantIcon
            titleText
            timestampText
            categoryTag
        }
    }

    @ViewBuilder
    private var importantIcon: some View {
        if item.isImportant {
            Image(systemName: "exclamationmark.3")
                .symbolVariant(.fill)
                .foregroundColor(.red)
                .font(.largeTitle)
                .bold()
        }
    }

    @ViewBuilder
    private var titleText: some View {
        Text(item.title)
            .font(.largeTitle)
            .bold()
    }

    @ViewBuilder
    private var timestampText: some View {
        Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
            .font(.callout)
    }

    @ViewBuilder
    private var categoryTag: some View {
        if let todoItemCategory = item.category {
            Text("\(todoItemCategory.title)")
                .foregroundStyle(.blue)
                .bold()
                .padding()
                .background(
                    Color.blue.opacity(0.1),
                    in: RoundedRectangle(
                        cornerRadius: 8,
                        style: .continuous
                    )
                )
        }
    }

    @ViewBuilder
    private var completeButton: some View {
        Button {
            withAnimation {
                item.isCompleted.toggle()
                do {
                    try item.modelContext?.save()
                } catch {
                    print("Failed to persist completion toggle: \(error)")
                }
            }
        } label: {
            Image(systemName: "checkmark")
                .symbolVariant(.circle.fill)
                .foregroundStyle(item.isCompleted ? .green : .gray)
                .font(.largeTitle)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    List {
        TodoItemRowView(
            item: TodoItem(
                title: "Test",
                timestamp: .now,
                isImportant: true,
                isCompleted: true
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test",
                timestamp: .now,
                isImportant: true,
                isCompleted: false
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test",
                timestamp: .now,
                isImportant: false,
                isCompleted: true
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test",
                timestamp: .now,
                isImportant: false,
                isCompleted: false
            )
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Test",
                    timestamp: .now,
                    isImportant: true,
                    isCompleted: true
                )
                item.category = TodoItemCategory(title: "Work")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Test",
                    timestamp: .now,
                    isImportant: true,
                    isCompleted: false
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Test",
                    timestamp: .now,
                    isImportant: false,
                    isCompleted: true
                )
                item.category = TodoItemCategory(title: "Errands")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Test",
                    timestamp: .now,
                    isImportant: false,
                    isCompleted: false
                )
                item.category = TodoItemCategory(title: "Home")
                return item
            }()
        )
    }
}
