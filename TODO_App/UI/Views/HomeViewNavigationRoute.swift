//
//  HomeViewNavigationRoute.swift
//  TODO_App
//
//  Created by Sanket Sonje on 24/10/25.
//


enum HomeViewNavigationRoute: Hashable {
    case createTodoItem
    case editTodoItem(todoItem: TodoItem)
    case createTodoItemCategory
}
