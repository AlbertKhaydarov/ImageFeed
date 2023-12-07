//
//  Constants.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 06.11.2023.
//

import Foundation

enum AuthConsts {
    static let accessKey = "rXp58aIcV-yp_Uz4t0SnD8hfaZcEDRIppZsEl5rCuAw"
    static let secretKey = "o3M5Ojegbskcb2p8YeBH8l5qVSjWA6RCEguxia0-iKE"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    // MARK: - URL
    static let defaultBaseURL: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        return components.url
    }()
    
    static let baseURL: URL? = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "unsplash.com"
        return components.url
    }()
}
