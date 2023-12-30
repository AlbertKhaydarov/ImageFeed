//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 19.10.2023.
//
import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor.ypWhite
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.ypGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.ypWhite
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "exitButtonImage"), for: .normal)
        button.tintColor = UIColor.ypRed
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //   MARK: -  add  router
    var profileViewRouter: ProfileViewRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlack
        setupSubview()
        layoutSubviews()
        updateProfileDetails()
        
        self.profileViewRouter = ProfileViewRouter()
        
        presenter = ProfileViewPesenter(viewController: self)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                presenter?.updateAvatarImage()
            }
        presenter?.updateAvatarImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.width / 2
        userProfileImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileDetails()
    }
    
    //MARK: - use for tests
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.viewController = self
    }
    
    func updateAvatar(with image: UIImage) {
        userProfileImageView.kf.indicatorType = .activity
        userProfileImageView.image = image
    }
    
    func updateProfileDetails() {
        if let profileModel = presenter?.getProfileDetails() {
            userNamelabel.text = profileModel.userNamelabelText
            loginNameLabel.text = profileModel.loginNameLabeText
            descriptionLabel.text = profileModel.descriptionLabelText
        }
    }
    
    //MARK: - add switch after logout
    @objc func logoutButtonTapped() {
        if let alertMessage = presenter?.showExitAlert() {
            AlertPresenterTwoButtons.showAlert(alertMessages: alertMessage, on: self )
        }
    }
    
    func switchToSplashViewController() {
        if let profileViewRouter = profileViewRouter {
            let splashViewController = SplashViewController()
            profileViewRouter.switchToSplashViewController(to: splashViewController)
        }
    }
    
    private func setupSubview() {
        view.addSubview(userProfileImageView)
        view.addSubview(userNamelabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func layoutSubviews() {
        NSLayoutConstraint.activate([
            userProfileImageView.widthAnchor.constraint(equalToConstant: 70),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 70),
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userProfileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            userNamelabel.leadingAnchor.constraint(equalTo: userProfileImageView.leadingAnchor),
            userNamelabel.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: 8),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: userNamelabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: userProfileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo:userProfileImageView.centerYAnchor)
        ])
    }
}
