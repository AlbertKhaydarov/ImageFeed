//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    
    //MARK: -  add protocol for storage (todo  a keychain)
    private var storage: StorageProtocol?
    
    //MARK: - use Singlton
    private let oauthService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = OAuth2TokenStorage()
        errorPresenter = ErrorAlertPresenter(delegate: self)
    }
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorAlertPresenterProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: - check token and routing
        guard let storage = storage else {return}
        if (storage.token) != nil {
            guard let token = storage.token else {return}
            fetchUserProfile(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    func showNetworkError() {
        let errorModel = ErrorAlertModel(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            buttonText: "Ok")
        { }
        self.errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

//MARK: - set delegate responsibility
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauthService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let token):
                self.fetchUserProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.desmiss()
                self.showNetworkError()
                break
            }
        }
    }
    
    private func fetchUserProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let profile):
                let username = profile.username
                ProfileImageService.shared.fetchProfileImageURL(token, username: username ) { _ in }
                UIBlockingProgressHUD.desmiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.desmiss()
                self.showNetworkError()
                break
            }
        }
    }
}

// MARK: - ErrorAlertPresenterDelegate
extension SplashViewController: ErrorAlertPresenterDelegate {
    func errorShowAlert() { }
}
