//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import Foundation
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(with image: UIImage)
    func updateProfileDetails()
    func switchToSplashViewController()
//    func configure(_ presenter: ProfileViewPresenterProtocol) 
    func logoutButtonTapped()
}
