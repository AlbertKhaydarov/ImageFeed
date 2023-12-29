//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var viewController: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    private var imagesListService: ImagesListService
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(viewController: ImagesListViewControllerProtocol) {
        self.viewController = viewController
        self.imagesListService = ImagesListService.shared
        fetchPhotosNextPage()
    }
    
    func changeLikeService(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { result in
            switch result {
            case .success():
                self.photos = self.imagesListService.photos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func getPhotosService() -> [Photo] {
        let photo = imagesListService.photos
        return photo
    }
    
    func getNotification() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                viewController?.updateTableViewAnimated()
            }
    }
}
