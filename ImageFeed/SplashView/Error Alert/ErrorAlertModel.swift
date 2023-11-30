//
//  ErrorAlertModel.swift
//  ImageFeed
//
//  Created by Admin on 30.11.2023.
//

import Foundation

struct ErrorAlertModel {
    let title: String
    let message: String
    let buttonText: String
    let errorAlertButtonAction: () -> Void
}
