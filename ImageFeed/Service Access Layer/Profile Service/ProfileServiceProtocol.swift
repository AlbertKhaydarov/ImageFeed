//
//  ProfileServiceProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.11.2023.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}
