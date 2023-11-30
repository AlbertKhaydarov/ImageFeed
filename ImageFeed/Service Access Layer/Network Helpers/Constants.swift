//
//  Constants.swift
//  ImageFeed
//
//  Created by Admin on 29.11.2023.
//

import Foundation

enum Constants {
    // MARK: - URL
    static let defaultBaseURL: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com1"
        return components.url
    }()
}
