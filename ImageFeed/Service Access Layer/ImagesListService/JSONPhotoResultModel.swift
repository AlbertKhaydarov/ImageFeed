//
//  JSONPhotoResultModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.12.2023.
//

import Foundation

struct JSONPhotoResultModel: Decodable {
    let id: String?
    let createdAt, updatedAt: String?
    let width, height: Int?
    let color, blurHash: String?
    let likes: Int?
    let likedByUser: Bool?
    let description: String?
//    let user: User?
    let urls: UrlsResult?
}

// MARK: - Urls
struct UrlsResult: Decodable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Decodable {
    let id, username, name: String
    let portfolioURL: String?
//    let bio: String?
//    let location: String

    
//    let totalLikes, totalPhotos, totalCollections: Int
//    let instagramUsername, twitterUsername: String
//    let profileImage: ProfileImage
//    let links: UserLinks
}

// MARK: - UserLinks
struct UserLinks: Decodable {
    let linksSelf, html, photos, likes: String
    let portfolio: String
}

