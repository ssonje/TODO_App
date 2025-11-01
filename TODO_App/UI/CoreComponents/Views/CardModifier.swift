//
//  CardModifier.swift
//  TODO_App
//
//  Created by Sanket Sonje on 26/10/25.
//

import SwiftUI

private struct CardModifier: ViewModifier {
    var padding: CGFloat = 12
    var cornerRadius: CGFloat = 14

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.secondary.opacity(0.08), lineWidth: 1)
            )
    }
}

extension View {
    func card(padding: CGFloat = 16, cornerRadius: CGFloat = 16) -> some View {
        modifier(CardModifier(padding: padding, cornerRadius: cornerRadius))
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Arbitrary content")
                    .font(.headline)
                Text("This is just any view using .card()")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .card()
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
