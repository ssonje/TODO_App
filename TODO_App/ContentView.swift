//
//  ContentView.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation
import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = TestViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView()
}
