//
//  MockStorage.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import UIKit
@testable import ImageFeed

final class MockStorage: StorageProtocol {
    var token: String?
    
    var removeTokenFromStorageCalled = false
    
    func removeToken() {
        removeTokenFromStorageCalled = true
    }
}
