//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var viewController: ProfileViewControllerProtocol? { get set }
    func updateAvatarImage()
    func getProfileDetails() -> ProfileViewModelProtocol
    func showExitAlert() -> TwoButtonsAlertModel
}
