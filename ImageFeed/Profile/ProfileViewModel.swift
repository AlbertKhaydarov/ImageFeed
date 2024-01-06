//
//  ProfileViewModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.12.2023.
//

import Foundation

public protocol ProfileViewModelProtocol {
    var userNamelabelText: String? { get }
    var loginNameLabeText: String? { get }
    var descriptionLabelText: String? { get }
}

struct ProfileViewModel: ProfileViewModelProtocol {
    let userNamelabelText: String?
    let loginNameLabeText: String?
    let descriptionLabelText: String?
}
