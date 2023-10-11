//
//  UIColors+Extensions.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black}
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var YPWhiteBackground: UIColor { UIColor(named: "YP White background") ?? UIColor.white.withAlphaComponent(0.5) }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white}
    static var YPBackground: UIColor { UIColor(named: "YP Background") ?? UIColor.black.withAlphaComponent(0.5)}
}

