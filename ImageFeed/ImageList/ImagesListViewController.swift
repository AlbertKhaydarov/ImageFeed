//
//  ViewController.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorAlertPresenterProtocol?
    
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        errorPresenter = ErrorAlertPresenter(delegate: self)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }

    //        MARK: -  Animated update of the table state
    private func updateTableViewAnimated() {
        let currentPhotosCount = photos.count
        let newPhotosCount = imagesListService.photos.count
        photos = imagesListService.photos
        if currentPhotosCount != newPhotosCount {
            tableView.performBatchUpdates {
                let indexPaths = (currentPhotosCount..<newPhotosCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
                tableView.reloadRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = String(indexPath.row)
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
//        guard let imageForCell = UIImage(named: imageName) else {return}
//        let cache = ImageCache.default
        let url = URL(string: photos[indexPath.row].thumbImageURL)
        let imageView = UIImageView()
        cell.imageForCell.kf.indicatorType = .activity
        cell.imageForCell.kf.setImage(with: url, placeholder: UIImage(named: "Stub"))
//        { result in
//            switch result {
//            case .success(let imageView):
//                cell.imageForCell.image = imageView.image
//            case .failure(let error):
//                assertionFailure("Failed to download photo \(error)", file: #file, line: #line)
//            }
//        }
 
     
        cell.imageForCell.image = imageView.image
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
    
    func showNetworkError() {
        let errorModel = ErrorAlertModel(
            title: "Что-то пошло не так",
            message: "Ошибка загрузки",
            buttonText: "Ok")
        { }
        self.errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }

   
}

extension ImagesListViewController: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photos[indexPath.row]) else {return 0}
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let heightForCell = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
//        return heightForCell
//    }
}


// MARK: - ErrorAlertPresenterDelegate
extension ImagesListViewController: ErrorAlertPresenterDelegate {
    func errorShowAlert() { }
}
