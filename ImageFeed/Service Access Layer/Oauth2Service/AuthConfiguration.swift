//
//  Constants.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 06.11.2023.
//

import Foundation

enum AuthConsts {
    //MARK: - first accout
    static let accessKey = "rXp58aIcV-yp_Uz4t0SnD8hfaZcEDRIppZsEl5rCuAw"
    static let secretKey = "o3M5Ojegbskcb2p8YeBH8l5qVSjWA6RCEguxia0-iKE"
    //MARK: - second accout
//    static let accessKey = "vVCXb0fd71SRmbyFJ7fcmcKD9jiumZ5lym6577JXVsw"
//    static let secretKey = "XvbeqMjO8H1fC6cIaV60yvRgYqqeYQhIrY8mi-0NMjQ"
    
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
