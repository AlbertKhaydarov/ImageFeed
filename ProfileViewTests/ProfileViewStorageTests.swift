//
//  ProfileViewStorageTests.swift
//  ProfileViewTests
//
//  Created by Альберт Хайдаров on 29.12.2023.
//

import Foundation
import XCTest
@testable import ImageFeed

class ProfileViewStorageTests: XCTestCase {
    var vc: ProfileViewController!
    var sut: ProfileViewPresenterSpy!
  
    
    override func setUp() {
        super.setUp()
        var vc = ProfileViewController()
        sut = ProfileViewPresenterSpy()
        vc.configure(sut)
    }
    
    override func tearDown() {
        vc = nil
        super.tearDown()
    }
    
    func testShowExitAlert() {
        // Given
        let mockStorage = MockStorage()
        sut.storage = mockStorage
        
        // When
//        sut.showExitAlert()
        vc.logoutButtonTapped()
        // Then
        XCTAssertTrue(mockStorage.removeTokenFromStorageCalled, "removeTokenFromStorage должен быть вызван")
    }
}

class MockStorage: StorageProtocol {
    var token: String?
    
    func removeToken() {
    }
    
    var removeTokenFromStorageCalled = false

    func removeTokenFromStorage() {
        removeTokenFromStorageCalled = true
    }
}

