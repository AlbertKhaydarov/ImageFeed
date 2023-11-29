//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 19.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var profileService: ProfileServiceProtocol?

    private lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "myAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userNamelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Альберт Хайдаров"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "@albert_khaydarov"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YP Gray")
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "exitButtonImage"), for: .normal)
        button.tintColor = UIColor(named: "YP Red")
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var storage: StorageProtocol?
       
    override func viewDidLoad() {
        super.viewDidLoad()
        profileService = ProfileService()
        storage = OAuth2TokenStorage()

        view.backgroundColor = UIColor(named: "YP Black")
        setupSubview()
        layoutSubviews()
   
        //MARK: - check token and routing
            guard let storage = storage else {return}
            if (storage.token) != nil {
                guard let token = storage.token else {return}
                fetchUserProfile(token: token)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.width / 2
        userProfileImageView.layer.masksToBounds = true
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        print(#function)
    }
    
    private func fetchUserProfile(token: String) {
        profileService?.fetchProfile(token)  { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let profile):
                userNamelabel.text = profile.name
                loginNameLabel.text = profile.loginName
                descriptionLabel.text = profile.bio
            case .failure:
                break
            }
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
