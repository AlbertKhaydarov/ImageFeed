//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Admin on 07.11.2023.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
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
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken  = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {try decoder.decode(OAuthTokenResponseBody.self, from: data)}
            }
                completion(response)
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
                        + "?client_id=\(accessKey)"
                        + "&&client_secret=\(secretKey)"
                        + "&&redirect_uri=\(redirectURI)"
                        + "&&code=\(code)"
                        + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl: baseURL)
    }
    
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseUrl: URL? = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseUrl) ?? URL(fileURLWithPath: "https://api.unsplash.com/"))
        request.httpMethod = httpMethod
        return request
    }
}

// MARK: - Network Connection

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

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
} }
