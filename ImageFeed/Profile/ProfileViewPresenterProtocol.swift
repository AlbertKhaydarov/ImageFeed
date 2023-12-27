//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var viewController: ProfileViewControllerProtocol? { get set }
    func updateAvatar()
   
}
