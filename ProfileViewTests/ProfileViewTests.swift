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
        sut.configure(presenter)
        
        //MARK: - when
        sut.logoutButtonTapped()
        
        //MARK: - then
        XCTAssertTrue(presenter.showExitAlertCalled)
    }
   
    var viewController: ProfileViewControllerProtocol?

    func testProfileViewControllerRevoveToken(){
        
        //MARK: - given
            let sut = ProfileViewController()
            let presenter = ProfileViewPresenterSpy()
            sut.configure(presenter)

        
        //MARK: - when
        sut.logoutButtonTapped()
        
        
        //MARK: - then
       
        XCTAssertTrue(presenter.removeTokenFromStorageCalled)
      
    }
//    let profileModel = presenter.getProfileDetails()
//    XCTAssertTrue((profileModel.userNamelabelText == "userNamelabelText"))
//    XCTAssertTrue((profileModel.loginNameLabeText == "loginNameLabeText"))
//    XCTAssertTrue((profileModel.descriptionLabelText == "descriptionLabelText"))
}
