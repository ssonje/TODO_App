//
//  TextStyleModifier.swift
//  TODO_App
//
//  Created by Sanket Sonje on 26/10/25.
//

import SwiftUI

// MARK: - Preset Styles

enum TodoTextStyle {
    case title
    case subtitle
    case secondary
    case caption
    case tag(color: Color)

    var font: Font {
        switch self {
        case .title:
            return .headline
        case .subtitle:
            return .subheadline
        case .secondary:
            return .body
        case .caption, .tag:
            return .caption
        }
    }

    var color: Color {
        switch self {
        case .title:
            return .primary
        case .subtitle:
            return .secondary
        case .secondary:
            return .secondary
        case .caption:
            return .secondary
        case .tag(let color):
            return color
        }
    }
}

// MARK: - Modifier

private struct TodoTextModifier: ViewModifier {
    let style: TodoTextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundStyle(style.color)
            .multilineTextAlignment(.leading)
    }
}

extension View {
    /// Apply a preset text style in one call
    func style(_ style: TodoTextStyle) -> some View {
        modifier(TodoTextModifier(style: style))
    }

    /// Apply custom font and color in one call
    func text(font: Font, color: Color) -> some View {
        modifier(TodoTextModifier(style: .secondary))
            .font(font)
            .foregroundStyle(color)
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        Text("Task title").style(.title)
        Text("This is very long long long long long long long long long long long long text ").style(.title)
        Text("Category").style(.subtitle)
        Text("Some helper text").style(.secondary)
        Text("Small caption").style(.caption)
        Text("High").style(.tag(color: .red))
        Text("Custom call")
            .text(font: .title3.weight(.semibold), color: .purple)
    }
    .padding()
}
