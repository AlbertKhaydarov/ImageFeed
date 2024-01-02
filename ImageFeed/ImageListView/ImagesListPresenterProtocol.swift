//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject  {
    var viewController: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    
    func getNotification()
    func fetchPhotosNextPage()
    func getPhotosService() -> [Photo]
    func changeLikeService(_ cell: ImagesListCell, indexPath: IndexPath)
}
