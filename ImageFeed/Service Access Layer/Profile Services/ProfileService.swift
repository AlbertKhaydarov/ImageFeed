//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.11.2023.
//

import Foundation

final class ProfileService {
    
    private var lastToken: String?
    
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        //MARK: - add eliminating a potential Data Race
        assert(Thread.isMainThread)
        if lastToken == token {return}
        task?.cancel()
        lastToken = token
        
        var requestForBaseUserProfile = baseUserProfileRequest(token: token)
        requestForBaseUserProfile.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = object(for: requestForBaseUserProfile) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let profileResult):
                guard let username = profileResult.username,
                      let firstName = profileResult.firstName,
                      let lastName = profileResult.lastName,
                      let bio = profileResult.bio
                else {return}
                let profile = Profile(username: username,
                                      firstName: firstName,
                                      lastName: lastName,
                                      bio: bio)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    //MARK: - make a request
    private func baseUserProfileRequest(token: String) -> URLRequest {
        URLRequest.makeHTTPRequestForBaseUserProfile(
            path: "/me",
            httpMethod: "GET",
            baseUrl: Constants.defaultBaseURL)
    }
    
    //MARK: - handling the server response
    private func object(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            completion(result)
        }
        return task
    }
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequestForBaseUserProfile(
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

