//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import XCTest
@testable import ImageFeed

struct ProfileViewModelMock: ProfileViewModelProtocol {
    let userNamelabelText: String? = "userNamelabelText"
    let loginNameLabeText: String? = "loginNameLabeText"
    let descriptionLabelText: String? = "descriptionLabelText"
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol  {
    
    var viewController: ProfileViewControllerProtocol?
    
    var getProfileDetailsCalled: Bool = false
    var showExitAlertCalled: Bool = false
    var storage: StorageProtocol?
    
    func updateAvatarImage() {
    }
    
    func getProfileDetails() ->  ProfileViewModelProtocol {
        getProfileDetailsCalled = true
        let viewModel = ProfileViewModelMock()
        return viewModel
    }
    
    func showExitAlert() -> TwoButtonsAlertModel {
        showExitAlertCalled = true
        
        let alertModel = TwoButtonsAlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            logOutActionButtonText: "Да",
            cancelActionButtonText: "Нет")
        {[weak self] in
            guard let self = self else {return}
            storage?.removeToken()
        }
        return alertModel
    }
}

