//
//  AlertPresenterTwoButtons.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 21.12.2023.
//

import UIKit

final class AlertPresenterTwoButtons: AlertPresenterTwoButtonsProtocol {

    static func showAlert(alertMessages: TwoButtonsAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: alertMessages.title,
                                      message: alertMessages.message,
                                      preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: alertMessages.logOutActionButtonText, style: .default) { _ in
            alertMessages.alertButtonAction()
        }
        
        let cancelAction = UIAlertAction(title: alertMessages.cancelActionButtonText, style: .default) { _ in
            viewController.dismiss(animated: true)
        }
        
        alert.addAction(logOutAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}

