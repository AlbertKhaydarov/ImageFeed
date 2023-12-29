//
//  ProfileViewPesenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import UIKit
import Kingfisher

final class ProfileViewPesenter: ProfileViewPresenterProtocol {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    var profileViewHelper: ProfileViewHelperProtocol?
    
    private let profileService = ProfileService.shared
    
    //MARK: -  add protocol for storage
    private var storage: StorageProtocol?
    
    //MARK: -  add ErrorPresenter
    var alertPresenter: AlertPresenterTwoButtonsProtocol?
    
    init(viewController: ProfileViewControllerProtocol) {
        self.viewController = viewController
        self.profileViewHelper = ProfileViewHelper()
        self.storage = OAuth2TokenStorageSwiftKeychainWrapper.shared
    }
    
    func updateAvatarImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
            return
        }
        
        //MARK: -  download an image by Kingfisher and set the cache on the disk storage
        let cache = ImageCache.default
        cache.diskStorage.config.sizeLimit = 1000 * 1000 * 100
        profileViewHelper?.loadAvatarImageView(url: url) { result in
            switch result {
            case .success(let image):
                if let image = image {
                    self.viewController?.updateAvatar(with: image)
                }
            case .failure(let error):
                assertionFailure("Failed to download avatar image \(error)", file: #file, line: #line)
            }
        }
    }
    
    func getProfileDetails() -> ProfileViewModelProtocol {
        let profile = profileService.profile
        let viewModel = ProfileViewModel(userNamelabelText: profile?.username,
                                loginNameLabeText: profile?.loginName,
                                descriptionLabelText: profile?.bio)        
        return viewModel
    }
    
   
//    func showExitAlert() {
//        let alertModel = TwoButtonsAlertModel(
//            title: "Пока, пока!",
//            message: "Уверены, что хотите выйти?",
//            logOutActionButtonText: "Да",
//            cancelActionButtonText: "Нет")
//        {[weak self] in
//            guard let self = self else {return}
//            storage?.removeToken()
//            CleanCookieStorage.clean()
//            if let viewController = viewController {
//                viewController.switchToSplashViewController()
//            }
//        }
//        if let viewController = viewController as? ProfileViewController {
//            AlertPresenterTwoButtons.showAlert(alertMessages: alertModel, on: viewController )
//        }
//    }
    func showExitAlert() -> TwoButtonsAlertModel {
            let alertModel = TwoButtonsAlertModel(
                title: "Пока, пока!",
                message: "Уверены, что хотите выйти?",
                logOutActionButtonText: "Да",
                cancelActionButtonText: "Нет")
            {[weak self] in
                guard let self = self else {return}
                storage?.removeToken()
                CleanCookieStorage.clean()
                if let viewController = viewController {
                    viewController.switchToSplashViewController()
                }
            }
//            if let viewController = viewController as? ProfileViewController {
//                AlertPresenterTwoButtons.showAlert(alertMessages: alertModel, on: viewController )
//            }
        return alertModel
        }
}
