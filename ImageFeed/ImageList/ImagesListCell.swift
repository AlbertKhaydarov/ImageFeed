//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    lazy var imageForCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "0")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
   
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        return label
    }()
    
    lazy var backgroundDateLabelView: GradientView = {
        let label = GradientView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favoriteActiveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ImagesListCellDelegate?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
        contentView.backgroundColor = .ypBlack
        setupSubview()
        layoutSetup()
    }
    
    //MARK: - Like Button Clicked  function
    private func likeButtonClicked() {
       delegate?.imageListCellDidTapLike(self)
    }
    
    //MARK: - Cancel the Kingfisher operation when reusing
    override func prepareForReuse() {
        super.prepareForReuse()
        imageForCell.kf.cancelDownloadTask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageForCell.layer.cornerRadius = 16
        imageForCell.layer.masksToBounds = true
        
        backgroundDateLabelView.layer.cornerRadius = imageForCell.layer.cornerRadius
        backgroundDateLabelView.layer.masksToBounds = true
        backgroundDateLabelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setupSubview() {
        contentView.addSubview(imageForCell)
        imageForCell.addSubview(dateLabel)
        imageForCell.addSubview(backgroundDateLabelView)
        imageForCell.addSubview(favoriteActiveButton)
    }
    
    private func layoutSetup() {
        NSLayoutConstraint.activate([
            imageForCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageForCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageForCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageForCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageForCell.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imageForCell.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageForCell.trailingAnchor, constant: -8),
            
            backgroundDateLabelView.heightAnchor.constraint(equalToConstant: 30),
            backgroundDateLabelView.leadingAnchor.constraint(equalTo: imageForCell.leadingAnchor),
            backgroundDateLabelView.trailingAnchor.constraint(equalTo: imageForCell.trailingAnchor),
            backgroundDateLabelView.bottomAnchor.constraint(equalTo: imageForCell.bottomAnchor),
            
            favoriteActiveButton.heightAnchor.constraint(equalToConstant: 44),
            favoriteActiveButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteActiveButton.topAnchor.constraint(equalTo: imageForCell.topAnchor),
            favoriteActiveButton.trailingAnchor.constraint(equalTo: imageForCell.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
