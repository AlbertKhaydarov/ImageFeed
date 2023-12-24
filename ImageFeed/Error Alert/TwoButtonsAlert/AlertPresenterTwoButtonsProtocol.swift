//
//  ErrorAlertPresenterTwoButtonsProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import UIKit

protocol ErrorPresenterTwoButtonsProtocol {
    func showErrorAlert(errorMessages: ErrorTwoButtonsAlertModel, on viewController: UIViewController)
}

protocol AlertPresenterTwoButtonsProtocol {
   static func showAlert(alertMessages: TwoButtonsAlertModel, on viewController: UIViewController)
}
