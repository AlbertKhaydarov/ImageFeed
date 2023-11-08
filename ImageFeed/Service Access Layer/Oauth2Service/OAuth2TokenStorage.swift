//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Admin on 07.11.2023.
//

import Foundation

enum StorageKeys: String {
    case storageKey
}

//MARK: -  add protocol for storage (todo  a keychain)
protocol StorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: StorageProtocol {
    
    private let storage = UserDefaults.standard
    
    init() {}
    
    var token: String? {
        get {
            storage.string(forKey: StorageKeys.storageKey.rawValue)
        }
        set {
            storage.set(newValue, forKey: StorageKeys.storageKey.rawValue)
        }
    }
}
