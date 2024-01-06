//
//  ImageListViewTests.swift
//  ImageListViewTests
//
//  Created by Альберт Хайдаров on 30.12.2023.
import Foundation
import XCTest
@testable import ImageFeed

final class ImageListViewTests: XCTestCase {
    
    func testImagesListViewControllerUpdateTableViewAnimatedCalled() {
        //MARK: - given
        let sut = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        presenter.viewController = sut
        sut.configure(presenter)
        
        //MARK: - when
        presenter.getNotification()
        
        //MARK: - then
        XCTAssertTrue(presenter.getNotificationCalled)
    }
    
    func testImagesListViewControllerFetchPhotosNextPageCalled() {
        //MARK: - given
        let sut = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        presenter.viewController = sut
        sut.configure(presenter)
        
        //MARK: - when
        presenter.fetchPhotosNextPage()
        
        //MARK: - then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}
