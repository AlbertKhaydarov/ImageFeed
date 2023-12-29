//
//  ImagesListPresenterSpy.swift
//  ImageListViewTests
//
//  Created by Альберт Хайдаров on 30.12.2023.
//
import Foundation
import XCTest
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewController: ImagesListViewControllerProtocol?
    
    var photos: [ImageFeed.Photo] = []
    
    var getNotificationCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    
    func getNotification() {
        getNotificationCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func getPhotosService() -> [Photo] {
        var photos:  [Photo] = []
        let photo = Photo(id: "YpUFf0kOWQ0",
                          width: 8640,
                          height: 5760,
                          createdAt: nil,
                          welcomeDescription: "Red Necked Ostrich, Nature Reserve – NEOM, Saudi Arabia",
                          thumbImageURL: "https://images.unsplash.com/photo-1682687220945-922198770e60?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MjQ5OTl8MHwxfGFsbHx8fHx8fHx8fDE3MDM4ODc3OTB8&ixlib=rb-4.0.3&q=80&w=200",
                          largeImageURL: "https://images.unsplash.com/photo-1682687220945-922198770e60?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1MjQ5OTl8MHwxfGFsbHx8fHx8fHx8fDE3MDM4ODc3OTB8&ixlib=rb-4.0.3&q=85",
                          smallImageURL: "https://images.unsplash.com/photo-1682687220945-922198770e60?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1MjQ5OTl8MHwxfGFsbHx8fHx8fHx8fDE3MDM4ODc3OTB8&ixlib=rb-4.0.3&q=80&w=400",
                          isLiked: false)
        photos.append(photo)
        return photos
    }
    
    func changeLikeService(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    }
}
