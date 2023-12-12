//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.12.2023.
//

import Foundation

class ImagesListService {
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int? = nil
    
    static let shared = ImagesListService()
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    let storage: StorageProtocol = OAuth2TokenStorageSwiftKeychainWrapper.shared
    
    private init() {}
    
//    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
    func fetchPhotosNextPage() {
        guard task == nil else {return}
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        guard
            let token = storage.token,
            let request = photosRequest(token: token, page: nextPage)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.missingData)", file: #file, line: #line)
            return}
        
        let task = object(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let photoResults):
                let photosFromTask = photoResults.compactMap { photoResult -> Photo in
                    return Photo(id: photoResult.id ?? "",
                                 width: photoResult.width,
                                 height: photoResult.height,
                                 createdAt: photoResult.createdAt?.dateTimeDateFromString,
                                 welcomeDescription: photoResult.description,
                                 thumbImageURL: photoResult.urls?.thumb ?? "",
                                 largeImageURL: photoResult.urls?.full ?? "",
                                 isLiked: photoResult.likedByUser ?? false
                    )
                }
                photos.append(contentsOf: photosFromTask)
                NotificationCenter.default.post(name: ImagesListService.DidChangeNotification,
                                                object: self,
                                                userInfo: ["Photos": photos])
                self.task = nil
            case .failure(let error):
                assertionFailure("Failed to create Photo from JSON \(error)", file: #file, line: #line)
                self.task = nil
            }
        }
        self.task = task
    }
}

extension ImagesListService {
    //MARK: - make a request
    private func photosRequest(token: String, page: Int) -> URLRequest? {
        guard
            let defaultBaseURL = Constants.defaultBaseURL,
            var urlComponents = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return nil
        }
        
        // MARK: - ImagesListService photos request
        let perPage = 10
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        urlComponents.path = "/photos"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    //MARK: - handling the server response
    private func object(for request: URLRequest, completion: @escaping (Result<[JSONPhotoResultModel], Error>) -> Void) -> URLSessionTask {
        let task = urlSession.objectTask(for: request) { (result: Result<[JSONPhotoResultModel], Error>) in
            completion(result)
        }
        return task
    }
}
