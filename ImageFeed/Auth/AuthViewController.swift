//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    let showWebViewSegueIdentifier = "ShowWebView"
    
    let oauthService = OAuth2Service()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let oauthService = OAuth2Service.shared
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
        oauthService.fetchOAuthToken(code) { result in
            switch result {
            case .success(let authToken):
                let authToken = authToken
                print(authToken)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
