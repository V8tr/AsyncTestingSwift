//
//  URLRequest+Ext.swift
//  AsyncTesting
//
//  Created by Vadim Bulavin on 24.10.2020.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import Foundation

extension URLRequest {
    static func search(term: String) -> URLRequest {
        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = [
            .init(name: "media", value: "music"),
            .init(name: "entity", value: "song"),
            .init(name: "term", value: "\(term)")
        ]
        
        return URLRequest(url: components!.url!)
    }
}
