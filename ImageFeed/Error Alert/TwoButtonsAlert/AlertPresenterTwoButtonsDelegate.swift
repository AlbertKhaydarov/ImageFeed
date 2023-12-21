//
//  ErrorAlertPresenterTwoButtonsDelegate.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import Foundation
protocol ErrorPresenterTwoButtonsDelegate: AnyObject {
    func showErrorAlert()
    func hideErrorViewController(_ errorAlertPresenter: ErrorAlertPresenterTwoButtons)
}

protocol AlertPresenterTwoButtonsDelegate: AnyObject {
    func showAlert()
    func cancelLogoutViewController(_ alertPresenter: AlertPresenterTwoButtons)
}
