//
//  ErrorAlertPresenterTwoButtonsDelegate.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import Foundation
protocol ErrorAlertPresenterTwoButtonsDelegate: AnyObject {
    func errorShowAlert()
    func hideErrorViewController(_ errorAlertPresenter: ErrorAlertPresenterTwoButtons)
}
