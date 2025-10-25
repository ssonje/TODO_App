//
//  CreateTodoItemView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 20/10/25.
//

import SwiftUI

struct CreateTodoItemView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel = CreateTodoItemViewModel()

    // MARK: - View

    var body: some View {
        List {
            Section("Title") {
                TextField("Todo Item Title", text: $viewModel.title)
            }

            Section("Details") {
                DatePicker(
                    "Choose a date",
                    selection: $viewModel.timestamp
                )

                Toggle("Important?", isOn: $viewModel.isImportant)
            }

            Section {
                HStack {
                    Spacer()

                    Button("Create todo") {
                        withAnimation {
                            viewModel.createTodoItem(modelContext: modelContext)
                        }
                        dismiss()
                    }

                    Spacer()
                }
            }
        }
        .navigationTitle("Create todo")
    }
}

// MARK: - Preview

#Preview {
    return NavigationStack {
        CreateTodoItemView()
    }
    .modelContainer(for: TodoItem.self)
}
