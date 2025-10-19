//
//  TestViewModel.swift
//  TODO_App
//
//  Created by Sanket Sonje on 19/10/25.
//

import SwiftUI

class TestViewModel: ObservableObject {

    @Injected private var logger: LoggerAPI
    @Injected private var networkManagerAPI: NetworkManagerAPI

    func onAppear() {
        networkManagerAPI.fetchData(from: URL(string: "https://jsonplaceholder.typicode.com/todos")!, completion: { [weak self] (result: Result<[Todo], Error>) in
            guard let self else { return }

            switch result {
            case .success(let todos):
                logger.info("\(todos)")

            case .failure(let error):
                logger.info(error.localizedDescription)
            }
        })
    }
}

struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool

    private enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case completed = "completed"
    }
}
