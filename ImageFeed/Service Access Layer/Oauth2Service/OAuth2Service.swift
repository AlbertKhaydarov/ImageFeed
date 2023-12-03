//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Admin on 07.11.2023.
//

import Foundation

final class OAuth2Service {
    
    //MARK: - use Singlton
    static let shared = OAuth2Service()
    
    //MARK: -  add protocol for storage (todo  a keychain)
//    private var storage: StorageProtocol? = OAuth2TokenStorageUserDefault()
    private var storage: StorageProtocol? = OAuth2TokenStorageKeychain()
    
    private let urlSession = URLSession.shared
    
    private (set) var authToken: String? {
        get {
            return storage?.token
        }
        set {
            storage?.token = newValue
        }
    }

    private var lastCode: String?
    
    private var task: URLSessionTask?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        //MARK: - add eliminating a potential Data Race 
        assert(Thread.isMainThread)
        if lastCode == code {return}
        task?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    
    //MARK: - handling the server response
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            completion(result)
        }
    }
    
    //MARK: - make a request
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AuthConsts.accessKey)"
            + "&&client_secret=\(AuthConsts.secretKey)"
            + "&&redirect_uri=\(AuthConsts.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl: AuthConsts.baseURL)
    }
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseUrl: URL? = AuthConsts.defaultBaseURL
    ) -> URLRequest {
        
        //MARK: - Unwrap optional URL
        guard let fullUrl = URL(string: path, relativeTo: baseUrl) else {fatalError("Failed to create full URL \(NetworkError.invalidURL)")}
        var request = URLRequest(url: fullUrl)
        request.httpMethod = httpMethod
        return request
    }
}
