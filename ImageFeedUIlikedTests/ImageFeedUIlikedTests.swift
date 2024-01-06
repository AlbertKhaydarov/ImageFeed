//
//  ImageFeedUIlikedTests.swift
//  ImageFeedUIlikedTests
//
//  Created by Альберт Хайдаров on 02.01.2024.
//
import Foundation
import XCTest
@testable import ImageFeed

final class ImageFeedUIlikedTests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
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
}
