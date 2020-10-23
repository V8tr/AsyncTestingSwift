//
//  MusicServiceWithoutDependency.swift
//  AsyncTesting
//
//  Created by Vadim Bulavin on 24.10.2020.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation

struct MusicServiceWithoutDependency {
    
    func search(_ term: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        URLSession.shared.dataTask(with: .search(term: term)) { data, response, error in
            DispatchQueue.main.async {
                completion(self.parse(data: data, error: error))
            }
        }.resume()
    }
    
    func parse(data: Data?, error: Error?) -> Result<[Track], Error> {
        if let data = data {
            return Result { try JSONDecoder().decode(SearchMediaResponse.self, from: data).results }
        } else {
            return .failure(error ?? URLError(.badServerResponse))
        }
    }
}
