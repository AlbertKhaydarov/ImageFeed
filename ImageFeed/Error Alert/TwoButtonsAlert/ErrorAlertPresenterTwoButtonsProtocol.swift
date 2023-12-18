//
//  ErrorAlertPresenterTwoButtonsProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import UIKit

protocol ErrorAlertPresenterTwoButtonsProtocol {
    func errorShowAlert(errorMessages: ErrorTwoButtonsAlertModel, on viewController: UIViewController)
}
