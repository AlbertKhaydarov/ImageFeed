//
//  WebViewTests.swift
//  WebViewTests
//
//  Created by Альберт Хайдаров on 25.12.2023.
//
import XCTest
import Foundation
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testProgressHiddenWhenOne() {
        //MARK: - given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //MARK: - when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //MARK: - then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //MARK: - given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //MARK: - when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //MARK: - then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testPresenterCallsLoadRequest() {
        //MARK: - given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //MARK: - when
        presenter.viewDidLoad()
        
        //MARK: - then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testViewControllerCallsViewDidLoad() {
        //MARK: - given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //MARK: - when
        _ = viewController.view
        
        //MARK: - then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
}
