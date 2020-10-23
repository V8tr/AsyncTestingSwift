//
//  MusicService.swift
//  AsyncTesting
//
//  Created by Vadym Bulavin on 2/28/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation

protocol HTTPClient {
    func execute(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}

struct MusicService {
    let httpClient: HTTPClient
    
    func search(_ term: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        httpClient.execute(request: .search(term: term)) { result in
            completion(self.parse(result))
        }
    }
    
    private func parse(_ result: Result<Data, Error>) -> Result<[Track], Error> {
        result.flatMap { data in
            Result { try JSONDecoder().decode(SearchMediaResponse.self, from: data).results }
        }
    }
}

class RealHTTPClient: HTTPClient {
    func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(error!))
                }
            }
        }.resume()
    }
}
