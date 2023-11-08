//
//  Constants.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 06.11.2023.
//

import Foundation

let AccessKey = "rXp58aIcV-yp_Uz4t0SnD8hfaZcEDRIppZsEl5rCuAw"
let SecretKey = "o3M5Ojegbskcb2p8YeBH8l5qVSjWA6RCEguxia0-iKE"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

// MARK: - URL
var DefaultBaseURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.unsplash.com"
    return components.url
}

var BaseURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "unsplash.com"
    return components.url
}
