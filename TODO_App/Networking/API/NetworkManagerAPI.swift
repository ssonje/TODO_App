//
//  NetworkManagerAPI.swift
//  TODO_App
//
//  Created by Sanket Sonje on 15/10/25.
//

import Foundation

/// Network base protocol which provides the get, post, put and delete api's
public protocol NetworkManagerAPI {
    
    /// Fetch data from provided URL and provides the Result `T` and error `Error`.
    func fetchData<T>(from: URL, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable
    
}
