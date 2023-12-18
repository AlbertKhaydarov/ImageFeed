//
//  ErrorAlertPresenterTwoButtons.swift
//  ImageFeed
//
//  Created by Admin on 18.12.2023.
//

import UIKit

final class ErrorAlertPresenterTwoButtons: ErrorAlertPresenterProtocol {
    
    weak var delegate: ErrorAlertPresenterDelegate?
    
    init(delegate: ErrorAlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func errorShowAlert(errorMessages: ErrorAlertModel, on viewController: UIViewController) {
        let alert = UIAlertController(title: errorMessages.title,
                                      message: errorMessages.message,
                                      preferredStyle: .alert)
        
        let hideAction = UIAlertAction(title: "Не надо", style: .default) { _ in
            delegate.dismiss(animated: true, completion: nil)
        }

        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            delegate.
            }
            
            alert.addAction(hideAction)
            alert.addAction(retryAction)

        let action = UIAlertAction(title: errorMessages.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            
            errorMessages.errorAlertButtonAction()
            self.delegate?.errorShowAlert()
        }
        
        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
