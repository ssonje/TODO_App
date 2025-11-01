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
        if let isImportant = item.isImportant, isImportant == true {
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
        if let timestamp = item.timestamp {
            Text("\(timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                .font(.callout)
        }
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
                item.completed.toggle()
                do {
                    try item.modelContext?.save()
                } catch {
                    print("Failed to persist completion toggle: \(error)")
                }
            }
        } label: {
            Image(systemName: "checkmark")
                .symbolVariant(.circle.fill)
                .foregroundStyle(item.completed ? .green : .gray)
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
                title: "Test 1",
                completed: true,
                timestamp: .now,
                isImportant: true
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test 2",
                completed: false,
                timestamp: .now,
                isImportant: true
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test 3",
                completed: true,
                timestamp: .now,
                isImportant: false
            )
        )

        TodoItemRowView(
            item: TodoItem(
                title: "Test 4",
                completed: false,
                timestamp: .now,
                isImportant: false
            )
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Work Item",
                    completed: true,
                    timestamp: .now,
                    isImportant: true
                )
                item.category = TodoItemCategory(title: "Work")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Personal Item",
                    completed: false,
                    timestamp: .now,
                    isImportant: true
                )
                item.category = TodoItemCategory(title: "Personal")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Errands Item",
                    completed: true,
                    timestamp: .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Errands")
                return item
            }()
        )

        TodoItemRowView(
            item: {
                let item = TodoItem(
                    title: "Home Item",
                    completed: false,
                    timestamp: .now,
                    isImportant: false
                )
                item.category = TodoItemCategory(title: "Home")
                return item
            }()
        )
    }
}
