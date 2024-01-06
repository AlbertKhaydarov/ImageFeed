//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 24.12.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
