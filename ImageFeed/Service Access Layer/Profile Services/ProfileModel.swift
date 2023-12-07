//
//  ProfileViewModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.11.2023.
//

import Foundation

struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    var loginName: String {
        return "@\(username)"
    }
    
    let bio: String
}

