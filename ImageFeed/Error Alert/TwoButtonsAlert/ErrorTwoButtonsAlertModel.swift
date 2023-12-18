//
//  ErrorTwoButtonsAlertModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 18.12.2023.
//

import Foundation

struct ErrorTwoButtonsAlertModel {
    let title: String
    let message: String
    let hideActionButtonText: String
    let retryActionButtonText: String
    let errorAlertButtonAction: () -> Void
}
