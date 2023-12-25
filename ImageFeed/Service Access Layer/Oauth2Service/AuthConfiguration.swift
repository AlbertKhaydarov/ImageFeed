//
//  Constants.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 06.11.2023.
//

import Foundation

private enum AuthConsts {
    static let accessKey = "rXp58aIcV-yp_Uz4t0SnD8hfaZcEDRIppZsEl5rCuAw"
    static let secretKey = "o3M5Ojegbskcb2p8YeBH8l5qVSjWA6RCEguxia0-iKE"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    // MARK: - URL
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
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

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: URL
    let baseURL: URL
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, baseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
        self.baseURL = baseURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AuthConsts.accessKey,
                                 secretKey: AuthConsts.secretKey,
                                 redirectURI: AuthConsts.redirectURI,
                                 accessScope: AuthConsts.accessScope,
                                 authURLString: AuthConsts.unsplashAuthorizeURLString,
                                 defaultBaseURL: AuthConsts.defaultBaseURL ?? URL(fileURLWithPath: ""),
                                 baseURL: AuthConsts.baseURL ?? URL(fileURLWithPath: ""))
    }
}
