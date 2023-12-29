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
        
//        let profileModel = presenter?.getProfileDetails()
//        
//        presenter?.getProfileDetails()
//        
//        func updateProfileDetails() {
//            if let profileModel = presenter?.getProfileDetails() {
//                userNamelabel.text = profileModel.userNamelabelText
//                loginNameLabel.text = profileModel.loginNameLabeText
//                descriptionLabel.text = profileModel.descriptionLabelText
//            }
//        }
        //MARK: - given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //MARK: - when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //MARK: - then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
  
}
