//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    func showLikeTapError()
}
