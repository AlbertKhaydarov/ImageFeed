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
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
   
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
                guard let avatarURL = profileImage.large else {return}
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
            path: "/users/\(username)",
            httpMethod: "GET",
            baseUrl: Constants.defaultBaseURL
        )
    }
    
    //MARK: - handling the server response
    private func object(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in

            completion(result)
        }
        return task
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

        //MARK: - Create the URLRequest
        var request = URLRequest(url: fullUrl)
        request.httpMethod = httpMethod
        return request
    }
}
