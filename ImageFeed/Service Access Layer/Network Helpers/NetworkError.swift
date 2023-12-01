//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 29.11.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidURL
    case codeError
    case decodeError
}
