//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 28.11.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func desmiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

}