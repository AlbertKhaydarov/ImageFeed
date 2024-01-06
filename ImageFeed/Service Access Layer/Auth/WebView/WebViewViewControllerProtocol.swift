//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 24.12.2023.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest) 
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
