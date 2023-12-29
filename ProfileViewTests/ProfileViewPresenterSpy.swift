//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import XCTest
import ImageFeed
@testable import ImageFeed


struct ProfileViewModelMock: ProfileViewModelProtocol {
    let userNamelabelText: String? = "userNamelabelText"
    let loginNameLabeText: String? = "loginNameLabeText"
    let descriptionLabelText: String? = "descriptionLabelText"
}

class ProfileViewPresenterSpy: ProfileViewPresenterProtocol  {
 
    var viewController: ProfileViewControllerProtocol?
    var getProfileDetailsCalled: Bool = false
    var showExitAlertCalled: Bool = false
    var removeTokenFromStorageCalled: Bool = false
    var storage: StorageProtocol?
    var token = "oiewbf-wc"
    
    func updateAvatarImage() {
    }
    
    func getProfileDetails() -> ProfileViewModelProtocol {
        getProfileDetailsCalled = true
        let viewModel = ProfileViewModelMock()
        return viewModel
    }
    
    
    func showExitAlert() -> ImageFeed.TwoButtonsAlertModel {
        showExitAlertCalled = true
    
        let alertModel = ImageFeed.TwoButtonsAlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            logOutActionButtonText: "Да",
            cancelActionButtonText: "Нет")
        {[weak self] in
            guard let self = self else {return}
          removeTokenFromStorage()
        }
       return alertModel
    }
    
    private func removeTokenFromStorage() {
        removeTokenFromStorageCalled = true
    }
}
