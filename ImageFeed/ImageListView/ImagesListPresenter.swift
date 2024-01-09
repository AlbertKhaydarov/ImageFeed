//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation

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
    
    func changeLikeService(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let photoId = photo.id
        let isLike = photo.isLiked
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photoId, isLike: !isLike) { result in
            switch result {
            case .success():
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                assertionFailure("Failed to change Like \(error)", file: #file, line: #line)
                self.viewController?.showLikeTapError()
                UIBlockingProgressHUD.dismiss()
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
