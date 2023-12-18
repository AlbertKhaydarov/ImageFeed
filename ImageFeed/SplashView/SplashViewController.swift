//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splashScreenLogo")
        return  imageView
    }()
    
    //MARK: -  add protocol for storage
    private var storage: StorageProtocol?
    
    //MARK: - use Singlton
    private let oauthService = OAuth2Service.shared
    private let profileService = ProfileService.shared
//    private let profileImageService = ProfileImageService.shared
    
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorAlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = OAuth2TokenStorageSwiftKeychainWrapper.shared
        //MARK: - an alternative option
//              storage = OAuth2TokenStorageKeychain.shared
        view.backgroundColor = .ypBlack
        errorPresenter = ErrorAlertPresenter(delegate: self)
        setupSubview()
        layoutSubviews()
    }
    
    private func setupSubview() {
        view.addSubview(logoView)
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: - check token and routing
        guard let storage = storage else {return}
        if  let token = storage.token {
            fetchUserProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    func switchToAuthViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        guard
            let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else { fatalError("Failed to prepare for Show Authentication Screen)")}
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
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
                UIBlockingProgressHUD.dismiss()
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
                ProfileImageService.shared.fetchProfileImageURL(token: token, username: username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
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
