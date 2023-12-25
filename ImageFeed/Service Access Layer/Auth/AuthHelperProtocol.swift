//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 25.12.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
} 
