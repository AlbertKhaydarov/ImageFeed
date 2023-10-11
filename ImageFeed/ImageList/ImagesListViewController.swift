//
//  ViewController.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = String(indexPath.row)
        guard let imageForCell = UIImage(named: imageName) else {return}
        cell.imageForCell.image = imageForCell
        let date = Date()
        cell.dateLabel.text = dateFormatter.string(from: date)
        let favoriteActiveImage: UIImage!
        if indexPath.row % 2 == 0 {
            favoriteActiveImage = UIImage(named: "favoriteActive")
        } else {
            favoriteActiveImage = UIImage(named: "favoriteNoActive")
        }
        cell.favoriteActiveButton.setImage(favoriteActiveImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {return 0}
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let heightForCell = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
        return heightForCell
    }
}


