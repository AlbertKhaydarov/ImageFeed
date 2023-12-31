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
    
    private init() {}
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        //MARK: - add eliminating a potential Data Race
        assert(Thread.isMainThread)
        if lastToken == token {return}
        task?.cancel()
        lastToken = token
        
        guard var requestUserAvatar = userAvatarRequest(token: token, username: username) else {return}
        requestUserAvatar.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = object(for: requestUserAvatar) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let userResult):
                let profileImage = userResult.profileImage
                guard let avatarURL = profileImage.large else {
                    completion(.failure(NetworkError.missingData))
                    return}
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                object: self,
                                                userInfo: nil)
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
    }
}

extension ProfileImageService {
    //MARK: - make a request
    private func userAvatarRequest(token: String, username: String) -> URLRequest? {
        guard let request = URLRequest.makeHTTPRequestUserAvatar(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseUrl: Constants.defaultBaseURL
        ) else {return nil}
        return request
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
    ) -> URLRequest? {
        
        //MARK: - Unwrap optional URL
        guard let fullUrl = URL(string: path, relativeTo: baseUrl)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return nil
        }
        
        //MARK: - Create the URLRequest
        var request = URLRequest(url: fullUrl)
        request.httpMethod = httpMethod
        return request
    }
}
