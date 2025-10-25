//
//  CreateTodoItemOrCategoryMenuView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 24/10/25.
//

import SwiftUI

struct CreateTodoItemOrCategoryMenuView: View {

    // MARK: - Bindings

    @Binding var isPresented: Bool

    // MARK: - Callbacks

    let onCreateTodoItem: () -> Void
    let onCreateCategory: () -> Void

    // MARK: - Private State

    @State private var rotationAngle: Double = 0

    // MARK: - View

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            expandedMenu
            fabButton
        }
    }

    // MARK: - View Builders

    @ViewBuilder
    private var expandedMenu: some View {
        if isPresented {
            VStack(spacing: 8) {
                createItemButton
                Divider()
                createCategoryButton
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(.secondary.opacity(0.15))
            )
            .shadow(radius: 6, y: 2)
            .frame(width: 220, alignment: .trailing)
            .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }

    @ViewBuilder
    private var createItemButton: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isPresented = false
                rotationAngle -= 180
            }
            onCreateTodoItem()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "square.and.pencil")
                Text("Create todo item")
            }
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var createCategoryButton: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isPresented = false
                rotationAngle -= 180
            }
            onCreateCategory()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "folder.badge.plus")
                Text("Create category")
            }
            .padding(.vertical, 8)
        }
    }

    @ViewBuilder
    private var fabButton: some View {
        Button {
            let willOpen = !isPresented
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isPresented.toggle()
            }
            withAnimation(.easeInOut(duration: 0.35)) {
                rotationAngle += willOpen ? 180 : -180
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background(
                    Circle().fill(Color.accentColor)
                )
                .shadow(radius: 4)
                .rotationEffect(.degrees(rotationAngle))
        }
        .padding(.trailing, 32)
    }
}

// MARK: - Preview

#Preview("Create menu (closed)") {
    ZStack(alignment: .bottomTrailing) {
        Color.gray.opacity(0.1).ignoresSafeArea()
        CreateTodoItemOrCategoryMenuView(
            isPresented: .constant(false),
            onCreateTodoItem: {},
            onCreateCategory: {}
        )
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }
}

#Preview("Create menu (open)") {
    ZStack(alignment: .bottomTrailing) {
        Color.gray.opacity(0.1).ignoresSafeArea()
        CreateTodoItemOrCategoryMenuView(
            isPresented: .constant(true),
            onCreateTodoItem: {},
            onCreateCategory: {}
        )
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }
}

