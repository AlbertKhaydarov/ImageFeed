//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
