//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 19.10.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
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
        return button
    }()
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: -  add protocol for storage
    private var storage: StorageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = OAuth2TokenStorageSwiftKeychainWrapper.shared
        view.backgroundColor = UIColor.ypBlack
        setupSubview()
        layoutSubviews()
        guard let profile = profileService.profile else {return}
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.width / 2
        userProfileImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profile = profileService.profile else {return}
        updateProfileDetails(profile: profile)
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        //MARK: -  download an image by Kingfisher and set the cache on the disk storage
        let cache = ImageCache.default
        cache.diskStorage.config.sizeLimit = 1000 * 1000 * 100
        userProfileImageView.kf.indicatorType = .activity
        userProfileImageView.kf.setImage(with: url,
                                         placeholder: UIImage(named: "placeholder.jpeg"),
                                         options: [])
    }
    
    func updateProfileDetails(profile: Profile) {
        userNamelabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    //MARK: - add switch after logout
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        storage?.removeToken()
        print("please, after removeToken additional remove app from simulator for clear keychain")
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
