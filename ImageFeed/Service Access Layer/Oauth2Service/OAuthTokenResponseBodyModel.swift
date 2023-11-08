//
//  OAuthTokenResponseBodyModel.swift
//  ImageFeed
//
//  Created by Admin on 07.11.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
