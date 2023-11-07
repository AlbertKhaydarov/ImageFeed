//
//  Constants.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 06.11.2023.
//

import Foundation

let accessKey = "rXp58aIcV-yp_Uz4t0SnD8hfaZcEDRIppZsEl5rCuAw"
let secretKey = "o3M5Ojegbskcb2p8YeBH8l5qVSjWA6RCEguxia0-iKE"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
//let DefaultBaseURL = URL(string: "https://api.unsplash.com/")

// MARK: - URL
var defaultBaseURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.unsplash.com"
    return components.url
}

var baseURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "unsplash.com"
    return components.url
}
