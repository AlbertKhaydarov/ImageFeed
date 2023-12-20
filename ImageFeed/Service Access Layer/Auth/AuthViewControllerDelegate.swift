//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
} 
