//
//  ProfileResultModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.11.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
        let small: String?
}


