//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol  {
    var viewController: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func updateAvatarImage() {}
    
    func getProfileDetails() -> ProfileViewModelProtocol {
        let viewModel: ProfileViewModelProtocol?
        viewModel?.userNamelabelText = "userNamelabelText"
        viewModel.loginNameLabeText = "loginNameLabeText"
        viewModel.descriptionLabelText = "descriptionLabelText")
        return viewModel
    }
    func showExitAlert() {}
    
   
}
