//
//  Track.swift
//  AsyncTesting
//
//  Created by Vadim Bulavin on 24.10.2020.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation

struct SearchMediaResponse: Codable {
    let results: [Track]
}

struct Track: Codable, Equatable {
    let trackName: String?
    let artistName: String?
}
