//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    let showWebViewSegueIdentifier = "ShowWebView"
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let destinationVC = segue.destination as? WebViewViewController else { return }
                destinationVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
