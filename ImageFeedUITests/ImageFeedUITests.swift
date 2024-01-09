//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Альберт Хайдаров on 30.12.2023.
//

import Foundation
import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    //MARK: - login = "", password = "", fullName = "", username = "".  Please, input in file "TestConstants"
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(TestConstants.login)
        
        webView.swipeUp()
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(TestConstants.password)
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        
        sleep(8)
        cell.swipeUp()
        
        sleep(10)
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        let favoriteActiveButton = cellToLike.buttons["favoriteActiveButton"]
        XCTAssertTrue(favoriteActiveButton.waitForExistence(timeout: 10))
        
        favoriteActiveButton.tap()
        sleep(5)
        
        favoriteActiveButton.tap()
        sleep(5)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["navBackButton"]
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[TestConstants.fullName].exists)
        XCTAssertTrue(app.staticTexts[TestConstants.username].exists)
        sleep(3)
        app.buttons["logoutButton"].tap()
        sleep(3)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
