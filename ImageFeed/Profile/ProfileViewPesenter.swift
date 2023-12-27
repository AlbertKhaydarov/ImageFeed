//
//  ProfileViewPesenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 27.12.2023.
//

import Foundation
import Kingfisher

final class ProfileViewPesenter: ProfileViewPresenterProtocol {
    
    weak var viewController: ProfileViewControllerProtocol?
    
    init(viewController: ProfileViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func updateAvatar() {
        print("1")
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        //MARK: -  download an image by Kingfisher and set the cache on the disk storage
        let cache = ImageCache.default
        //        cache.clearMemoryCache()
        //        cache.clearDiskCache()
        cache.diskStorage.config.sizeLimit = 1000 * 1000 * 100
        
        viewController?.loadAvatarImageView(url: url)
        
    }
    
    
    
}
