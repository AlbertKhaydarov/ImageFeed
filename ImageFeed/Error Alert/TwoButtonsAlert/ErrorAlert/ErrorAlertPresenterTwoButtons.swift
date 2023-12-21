//
//  ErrorAlertPresenterTwoButtons.swift
//  ImageFeed
//
//  Created by Admin on 18.12.2023.
//

import UIKit

final class ErrorAlertPresenterTwoButtons: ErrorPresenterTwoButtonsProtocol {

    weak var delegate: ErrorPresenterTwoButtonsDelegate?
    
    init(delegate: ErrorPresenterTwoButtonsDelegate?) {
        self.delegate = delegate
    }
    
    func showErrorAlert(errorMessages: ErrorTwoButtonsAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: errorMessages.title,
                                      message: errorMessages.message,
                                      preferredStyle: .alert)
        
        let hideAction = UIAlertAction(title: errorMessages.hideActionButtonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.delegate?.hideErrorViewController(self)
        }

        let retryAction = UIAlertAction(title: errorMessages.retryActionButtonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            errorMessages.errorAlertButtonAction()
            self.delegate?.showErrorAlert()
            }
            
            alert.addAction(hideAction)
            alert.addAction(retryAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
