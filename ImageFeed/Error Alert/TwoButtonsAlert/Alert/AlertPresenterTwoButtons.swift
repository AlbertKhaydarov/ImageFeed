//
//  AlertPresenterTwoButtons.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 21.12.2023.
//

import UIKit

final class AlertPresenterTwoButtons: AlertPresenterTwoButtonsProtocol {

    weak var delegate: AlertPresenterTwoButtonsDelegate?
    
    init(delegate: AlertPresenterTwoButtonsDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(alertMessages: TwoButtonsAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: alertMessages.title,
                                      message: alertMessages.message,
                                      preferredStyle: .alert)
        
        let logOutAction = UIAlertAction(title: alertMessages.logOutActionButtonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            alertMessages.alertButtonAction()
            self.delegate?.showAlert()
        }

        let cancelAction = UIAlertAction(title: alertMessages.cancelActionButtonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.delegate?.cancelLogoutViewController(self)
            }
            
            alert.addAction(logOutAction)
            alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

