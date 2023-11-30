//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 30.11.2023.
//

import Foundation

final class ProfileImageService {
    
    private var lastToken: String?
    
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    static let shared = ProfileImageService()
    
    private (set) var avatarURL: String?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        //MARK: - add eliminating a potential Data Race
        assert(Thread.isMainThread)
        if lastToken == token {return}
        task?.cancel()
        lastToken = token
        
        var requestUserAvatar = userAvatarRequest(token: token, username: username)
        requestUserAvatar.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = object(for: requestUserAvatar) { [weak self] result in
            guard let self = self else {return}
   
            switch result {
            case .success(let userResult):
                let profileImage = userResult.profileImage
                guard let avatarURL = profileImage.small else {return}
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                object: self,
                                                userInfo: ["URL": avatarURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService {
    //MARK: - make a request
    private func userAvatarRequest(token: String, username: String) -> URLRequest {
        URLRequest.makeHTTPRequestUserAvatar(
            path: "/users/:\(username)",
            httpMethod: "GET",
            baseUrl: Constants.defaultBaseURL)
    }
    
    //MARK: - handling the server response
    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.userAvatarData(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                let result = Result {
                    try decoder.decode(UserResult.self, from: data)
                }
                return result
            }
            completion(response)
        }
    }
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequestUserAvatar(
        path: String,
        httpMethod: String,
        baseUrl: URL?
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
    func userAvatarData(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
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

