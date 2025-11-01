//
//  SortField.swift
//  TODO_App
//
//  Created by Sanket Sonje on 25/10/25.
//

enum SortField: String, CaseIterable, Identifiable {
    case todoTitle
    case date
    case categoryTitle

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .todoTitle:
            return "Title"
        case .date:
            return "Date"
        case .categoryTitle:
            return "Category"
        }
    }
}
