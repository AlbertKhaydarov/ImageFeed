//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 03.12.2023.
//

import Foundation
import Security
import SwiftKeychainWrapper

//MARK: -  There are three variants storage by use: SwiftKeychainWrapper, Keychain and UserDefaults

enum StorageKeys: String {
    case storageKey
    case appTag = "com.imagefeed.keys"
}

// MARK: -  use SwiftKeychainWrapper
final class OAuth2TokenStorageSwiftKeychainWrapper: StorageProtocol {
    
    init() {}
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: StorageKeys.storageKey.rawValue)
            return token
        }
        set {
            guard let token = newValue else {return}
            let isSuccess = KeychainWrapper.standard.set(token, forKey: StorageKeys.storageKey.rawValue)
            guard isSuccess else {
                print("Error saving token")
                return
            }
        }
    }
    // MARK: - Todo add for logoutButton action in ProfileViewController
    func removeToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: StorageKeys.storageKey.rawValue)
        
        guard removeSuccessful else {
            print("Error removeToken token")
            return
        }
    }
}

// MARK: -  use native Keychain
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
    
    // MARK: - Todo add for logoutButton action in ProfileViewController
    func removeToken() {
        let query: [String: Any]  = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: StorageKeys.appTag.rawValue,
        ]
        
        // MARK: - Delete item from keychain
        SecItemDelete(query as CFDictionary)
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

// MARK: -  use UserDefaults
final class OAuth2TokenStorageUserDefault: StorageProtocol {
    func removeToken() {
        storage.removeObject(forKey: StorageKeys.storageKey.rawValue)
    }

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
