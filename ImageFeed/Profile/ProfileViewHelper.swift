//
//  ProfileViewHelper.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.12.2023.
//

import Foundation
import Kingfisher
import UIKit

final class ProfileViewHelper: ProfileViewHelperProtocol {
   
    init() {}
   
    func loadAvatarImageView(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void)  {
        let imageView = UIImageView()
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpeg"), options: []) { result in
            switch result {
            case .success(let data):
                let image = data.image
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


