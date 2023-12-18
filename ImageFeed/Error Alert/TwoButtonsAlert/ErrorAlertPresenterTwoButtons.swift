//
//  ErrorAlertPresenterTwoButtons.swift
//  ImageFeed
//
//  Created by Admin on 18.12.2023.
//

import UIKit

final class ErrorAlertPresenterTwoButtons: ErrorAlertPresenterTwoButtonsProtocol {
    
    weak var delegate: ErrorAlertPresenterTwoButtonsDelegate?
    
    init(delegate: ErrorAlertPresenterTwoButtonsDelegate?) {
        self.delegate = delegate
    }
    
    func errorShowAlert(errorMessages: ErrorTwoButtonsAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: errorMessages.title,
                                      message: errorMessages.message,
                                      preferredStyle: .alert)
        
        let hideAction = UIAlertAction(title: errorMessages.hideActionButtonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.delegate?.hideErrorViewController(self)
        }

        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else {return}
            errorMessages.errorAlertButtonAction()
            self.delegate?.errorShowAlert()
            }
            
            alert.addAction(hideAction)
            alert.addAction(retryAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
