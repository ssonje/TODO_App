//
//  TodoItemCategoryView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 26/10/25.
//

import SwiftUI

struct TodoItemCategoryView: View {

    // MARK: - Properties

    private var title: String
    private var color: Color

    // MARK: - Initializer

    init(title: String, color: Color = .blue) {
        self.title = title
        self.color = color
    }

    // MARK: - View

    var body: some View {
        Text(title)
            .style(.tag(color: color))
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                color.opacity(0.12),
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        TodoItemCategoryView(title: "Home")
        TodoItemCategoryView(title: "Work", color: .orange)
        TodoItemCategoryView(title: "Personal", color: .purple)
    }
}
