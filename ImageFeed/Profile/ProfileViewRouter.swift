//
//  ProfileViewRouter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import UIKit

final class ProfileViewRouter: ProfileViewRouterProtocol {
    
    init() {}
    
    func switchToSplashViewController(to destimationVC: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        window.rootViewController = destimationVC
    }
}
