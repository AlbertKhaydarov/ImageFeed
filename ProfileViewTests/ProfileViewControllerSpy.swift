//
//  ProfileViewController.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import UIKit
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    func logoutButtonTapped() {
    }
    
    var presenter: ProfileViewPresenterProtocol?
    var updateAvatarCalled: Bool = false
    
    func updateAvatar(with image: UIImage) {
    updateAvatarCalled = true
    }
    
    func updateProfileDetails() {
        
    }
    
    func switchToSplashViewController() {
        
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        
    }
    
    
}
