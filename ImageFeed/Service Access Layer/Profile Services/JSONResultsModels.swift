//
//  ProfileResultModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.11.2023.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String?
    let medium: String?
    let large: String?
}


