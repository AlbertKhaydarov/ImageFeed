//
//  MyKFIndicator.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 12.12.2023.
//

import UIKit
import Kingfisher

struct MyKFIndicator: Indicator {
    var view: Kingfisher.IndicatorView
    func startAnimatingView() { view.isHidden = false }
    func stopAnimatingView() { view.isHidden = true }
}
