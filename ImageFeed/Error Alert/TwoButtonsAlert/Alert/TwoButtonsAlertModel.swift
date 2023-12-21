//
//  TwoButtonsAlertModel.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 21.12.2023.
//

import Foundation

struct TwoButtonsAlertModel {
    let title: String
    let message: String
    let logOutActionButtonText: String
    let cancelActionButtonText: String
    let alertButtonAction: () -> Void
}
