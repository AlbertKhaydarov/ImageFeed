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
    private var taskGetIsLike: URLSessionTask?
    private let urlSession = URLSession.shared
    
    let storage: StorageProtocol = OAuth2TokenStorageSwiftKeychainWrapper.shared
    
    private init() {}
    
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard taskGetIsLike == nil else {return}
        guard
            let token = storage.token
        else {
            assertionFailure("Failed to create full URL \(NetworkError.missingData)", file: #file, line: #line)
            return}
    

            guard let request = isLikeRequest(token: token, photoId: photoId, isLikeType: isLike) else {
                assertionFailure("Failed to create request \(String(describing: NetworkError.urlRequestError))", file: #file, line: #line)
                return }
            let task = objectGetIsLike(for: request) { [weak self] result in
                guard let self = self else {return}
               
                self.taskGetIsLike = nil
                //TODO remove result
                switch result {
                case .success(let photo):
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                       let photo = self.photos[index]
                       let newPhoto = Photo(
                                id: photo.id,
                                width: photo.width,
                                height: photo.height,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                smallImageURL: photo.smallImageURL,
                                isLiked: !photo.isLiked
                            )
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        print(photo.isLiked)
                    }
                    completion(.success(()))
                    self.taskGetIsLike = nil
                case .failure(let error):
                    assertionFailure("Failed to create Photo from JSON \(error)", file: #file, line: #line)
                    completion(.failure(error))
                    self.taskGetIsLike = nil
                }
            }
            self.taskGetIsLike = task
    }

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
                                 smallImageURL: photoResult.urls?.small ?? "",
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
    //MARK: - photos request
    private func photosRequest(token: String, page: Int) -> URLRequest? {
        guard
            let defaultBaseURL = Constants.defaultBaseURL,
            var urlComponents = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return nil
        }
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
    
    //MARK: - isLike request
    private func isLikeRequest(token: String, photoId: String, isLikeType: Bool) -> URLRequest? {
        guard
            let defaultBaseURL = Constants.defaultBaseURL,
            var urlComponents = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return nil
        }
        urlComponents.path = "/photos/\(photoId)/like"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if isLikeType == false {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "DELETE"
        }
        return request
    }
    //MARK: - handling the server response
    private func objectGetIsLike(for request: URLRequest, completion: @escaping (Result<JSONGetIsLikeModel, Error>) -> Void) -> URLSessionTask {
        let task = urlSession.objectTask(for: request) { (result: Result<JSONGetIsLikeModel, Error>) in
            completion(result)
        }
        return task
    }
}
