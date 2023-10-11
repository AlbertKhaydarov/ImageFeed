//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageForCell: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var backgroundDateLabelView: GradientView!
    
    @IBOutlet weak var favoriteActiveButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageForCell.layer.cornerRadius = 16
        imageForCell.layer.masksToBounds = true
        
        backgroundDateLabelView.layer.cornerRadius = imageForCell.layer.cornerRadius
        backgroundDateLabelView.layer.masksToBounds = true
        backgroundDateLabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
