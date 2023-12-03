//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 03.12.2023.
//

import Foundation
import SwiftKeychainWrapper
import Security

enum StorageKeys: String {
    case storageKey
    case appTag = "com.imagefeed.keys"
}

final class OAuth2TokenStorageUserDefault: StorageProtocol {
    
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

final class OAuth2TokenStorageKeychain: StorageProtocol {
    
    init() {}
    
    var token: String? {
        get {
            readUserToken()
        }
        set {
            saveUserToken(newValue)
        }
    }
}

private extension OAuth2TokenStorageKeychain {
    func saveUserToken(_ token: String?) {
        
        guard let token = token,
              let tokenData = token.data(using: .utf8)
        else {return}
        
        // MARK: - Create query
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: StorageKeys.appTag.rawValue,
            kSecValueData as String: tokenData]
        
        //MARK: - Add data in query to keychain
        var status = SecItemAdd(addQuery as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            // MARK: -Item already exist, thus update it.
            let updatQquery: [String: Any] = [
                kSecAttrService as String: StorageKeys.appTag.rawValue,
                kSecClass as String: kSecClassGenericPassword,
            ]
            
            let attributesToUpdate = [kSecValueData as String: tokenData] as CFDictionary
            
            // MARK: -Update existing item
            status = SecItemUpdate(updatQquery as CFDictionary, attributesToUpdate as CFDictionary)
        }
        
        guard status == errSecSuccess else {
            // MARK: - Print out the error
            print("Error saving token: \(status)")
            return
        }
    }
    
    func readUserToken() -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrService as String: StorageKeys.appTag.rawValue,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            return nil
        }
        
        guard let tokenData = result as? Data,
              let token = String(data: tokenData, encoding: String.Encoding.utf8)
        else {
            return nil
        }
        
        return (token)
    }
}
