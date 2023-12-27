//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func loadAvatarImageView(url: URL)
}
