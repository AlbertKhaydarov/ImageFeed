//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 25.12.2023.
//

import Foundation

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: AuthConfiguration.standard.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
        ]
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return URL(fileURLWithPath: "")}
        return url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
