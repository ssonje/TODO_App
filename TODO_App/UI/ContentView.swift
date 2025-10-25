//
//  ContentView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation
import SwiftData
import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = TestViewModel()

    var body: some View {
        HomeView()
            .modelContainer(for: TodoItem.self)
    }
}

#Preview {
    ContentView()
}
