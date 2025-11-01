//
//  TodoItemViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 26/10/25.
//

import Foundation
import SwiftData
import SwiftUI

final class TodoItemViewModel: ObservableObject {

    // MARK: - Properties

    @Published var item: TodoItem

    var isDueSoon: Bool {
        guard let timestamp = item.timestamp else { return false }
        let timeRemaining = timestamp.timeIntervalSince(Date())
        return timeRemaining >= 0 && timeRemaining <= 3600
    }

    var isOverdue: Bool {
        guard let timestamp = item.timestamp else { return false }
        return timestamp < Date()
    }

    private let onTap: (TodoItem) -> Void

    // MARK: - Init

    init(
        item: TodoItem,
        onTap: @escaping (TodoItem) -> Void
    ) {
        self.item = item
        self.onTap = onTap
    }

    // MARK: - Intents

    func handleTap() {
        onTap(item)
    }

    func deleteItem(modelContext: ModelContext) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            modelContext.delete(self.item)

            do {
                try modelContext.save()
            } catch {
                print("Failed to persist deletion: \(error)")
            }
        }
    }

    func toggleCompleted(modelContext: ModelContext?) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            item.completed.toggle()
            do {
                try modelContext?.save()
            } catch {
                print("Failed to persist completion toggle: \(error)")
            }
        }
    }
}
