//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 04.12.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "tabEditorialActive"),
                                                           selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tabProfileActive"),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
