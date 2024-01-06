//
//  ProfileViewController.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {

    var presenter: ProfileViewPresenterProtocol?
    
    func updateAvatar(with image: UIImage) {
    }
    
    func updateProfileDetails() {
    }
    
    func switchToSplashViewController() {
    }
    
    func logoutButtonTapped() {
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
    }
}
