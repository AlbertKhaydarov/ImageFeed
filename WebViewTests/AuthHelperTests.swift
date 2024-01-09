//
//  AuthHelperTests.swift
//  WebViewTests
//
//  Created by Admin on 26.12.2023.
//

import XCTest
import Foundation
@testable import ImageFeed

final class AuthHelperTests: XCTestCase {
    func testAuthHelperAuthURL() {
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
    
    func testCodeFromURL() {
        
        //MARK: - given
        let urlString = "https://unsplash.com/oauth/authorize/native"
        guard var urlComponents = URLComponents(string: urlString) else {return}
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        guard let url = urlComponents.url else { return }
        
        let authHelper = AuthHelper()
        
        //MARK: - when
        let code = authHelper.code(from: url)
        
        //MARK: - then
        XCTAssertEqual(code, "test code")
    }
}
