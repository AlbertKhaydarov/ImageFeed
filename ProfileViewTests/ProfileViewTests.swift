//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Admin on 26.12.2023.
//
import Foundation
import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testProfileViewControllerUpdateProfileDetails(){
        
        //MARK: - given
        let sut = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        sut.configure(presenter)
        
        //MARK: - when
        sut.updateProfileDetails()
        
        //MARK: - then
        XCTAssertTrue(presenter.getProfileDetailsCalled)
    }
    
    func testProfileViewControllerLogoutButtonTappedCalled(){
        
        //MARK: - given
        let sut = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        presenter.viewController = sut
        sut.configure(presenter)
        
        //MARK: - when
        sut.logoutButtonTapped()
        
        //MARK: - then
        XCTAssertTrue(presenter.showExitAlertCalled)
    }
    
    func testProfileViewPresenterRemoveTokenCalled(){
        
        //MARK: - given
        let sut = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        sut.configure(presenter)
        let mockStorage = MockStorage()
        presenter.storage = mockStorage
        
        //MARK: - when
        
        let action = presenter.showExitAlert()
        action.alertButtonAction()
        
        //MARK: - then
        XCTAssertTrue(mockStorage.removeTokenFromStorageCalled, "removeTokenFromStorage должен быть вызван")
    }
}
