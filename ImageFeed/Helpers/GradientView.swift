//
//  GradientView.swift
//  ImageFeed
//
//  Created by Admin on 11.10.2023.
//

import UIKit

final class GradientView: UIView {
    private var firstColor: UIColor = UIColor(named: "YP Black")?.withAlphaComponent(0.0) ?? UIColor.black.withAlphaComponent(0.0)
    private var secondColor: UIColor = UIColor(named: "YP Black")?.withAlphaComponent(0.2) ?? UIColor.black.withAlphaComponent(0.2)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        guard let layer = layer as? CAGradientLayer else {return}
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPointMake(0.5, 0.0)
        layer.endPoint = CGPointMake(0.5, 1.0)
        layer.type = .axial
        layer.locations = [0.0, 1.0]
    }
}
