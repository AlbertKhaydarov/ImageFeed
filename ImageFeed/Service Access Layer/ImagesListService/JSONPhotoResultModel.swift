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
}

struct JSONGetIsLikeModel: Decodable {
    let photo: JsonPhoto
    let user: JsonUser
}

struct JsonPhoto: Decodable {
    let id: String
    let likes: Int
    let likedByUser: Bool
}

struct JsonUser: Decodable {
    let id, username, name: String
    
}


