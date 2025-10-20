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
        do {
            let operation: NetworkOperationAPI = NetworkOperationAPIImpl(
                method: .get,
                path: "https://jsonplaceholder.typicode.com/todos",
                headers: [:],
                queryItems: [:],
                data: nil
            )
            let request = try operation.makeURLRequest()
            networkManagerAPI.executeRequest(request, completion: { [weak self] (result: Result<[Todo], Error>) in
                guard let self else { return }

                switch result {
                case .success(let todos):
                    logger.info("\(todos)")

                case .failure(let error):
                    logger.info(error.localizedDescription)
                }
            })
        } catch {
            print(error)
        }
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
