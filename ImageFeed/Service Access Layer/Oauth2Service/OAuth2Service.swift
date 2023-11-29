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
    private var storage: StorageProtocol? = OAuth2TokenStorage()
    
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
                self.authToken  = authToken
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
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {try decoder.decode(OAuthTokenResponseBody.self, from: data)}
            }
            completion(response)
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

// MARK: - Network Connection

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
