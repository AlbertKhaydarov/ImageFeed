//
//  PhotosViewModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.12.2023.
//

import Foundation

struct Photos {
    let photo: Photo
}

struct Photo {
    let id: String
    let width, height: Int?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let smallImageURL: String
    let isLiked: Bool
    
    var size: CGSize {
        return CGSize(width: Double(width ?? 0), height: Double(height ?? 0))
    }
    
}
