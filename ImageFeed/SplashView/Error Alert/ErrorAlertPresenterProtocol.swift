//
//  ErrorAlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Admin on 30.11.2023.
//

import UIKit

protocol ErrorAlertPresenterProtocol {
    func errorShowAlert(errorMessages: ErrorAlertModel, on viewController: UIViewController)
}
