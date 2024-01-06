//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) 
}
