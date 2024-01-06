//
//  ProfileViewHelperProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.12.2023.
//

import Foundation
import UIKit

protocol ProfileViewHelperProtocol {
    func loadAvatarImageView(url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void)
}
