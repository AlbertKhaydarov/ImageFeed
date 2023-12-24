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
    
    private lazy var loaderIndicatorBackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .ypWhite
        return imageView
    }()
    
    var loaderIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        errorPresenter = ErrorAlertPresenter(delegate: self)
        
        view.addSubview(loaderIndicatorBackImageView)
        loaderIndicatorBackImageView.addSubview(loaderIndicator)
        loaderIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutSetup()
        
        let indicator = MyKFIndicator(view: loaderIndicator)
        indicator.view.tintColor = .ypBlack
        indicator.startAnimatingView()
        
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
    
    private func layoutSetup() {
        NSLayoutConstraint.activate([
            loaderIndicatorBackImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderIndicatorBackImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderIndicatorBackImageView.widthAnchor.constraint(equalToConstant: 51),
            loaderIndicatorBackImageView.heightAnchor.constraint(equalToConstant: 51),
            
            loaderIndicator.centerXAnchor.constraint(equalTo: loaderIndicatorBackImageView.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: loaderIndicatorBackImageView.centerYAnchor)
        ])
    }
    
    //   MARK: -  Animated update of the table state
    private func updateTableViewAnimated() {
        let currentPhotosCount = photos.count
        let newPhotosCount = imagesListService.photos.count
        photos = imagesListService.photos
        if currentPhotosCount != newPhotosCount {
            tableView.performBatchUpdates {
                let indexPaths = (currentPhotosCount..<newPhotosCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .top)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.fullImageUrlString = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let url = URL(string: photos[indexPath.row].thumbImageURL)
        let imageView = cell.imageForCell
        
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Stub")) { _ in            self.loaderIndicatorBackImageView.isHidden = true
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        let isLiked = imagesListService.photos[indexPath.row].isLiked
        cell.setIsLiked(isLiked: isLiked)
    }
    
    private func calculateHeigthCell(for indexPath: IndexPath) -> CGFloat {
        let image = imagesListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let heightForCell = image.size.height * (imageViewWidth / (image.size.width)) + imageInsets.top + imageInsets.bottom
        return heightForCell
    }
    
    func showNetworkError() {
        let errorModel = ErrorAlertModel(
            title: "Что-то пошло не так",
            message: "Ошибка загрузки",
            buttonText: "Ok")
        { }
        self.errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }
    
    func showLikeTapError() {
        let errorModel = ErrorAlertModel(
            title: "Что-то пошло не так",
            message: "Ошибка в установке Like",
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
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heigth = calculateHeigthCell(for: indexPath)
        return heigth
    }
}

// MARK: - ErrorAlertPresenterDelegate
extension ImagesListViewController: ErrorAlertPresenterDelegate {
    func errorShowAlert() { }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        let photoId = photo.id
        let isLike = photo.isLiked
        imagesListService.changeLike(photoId: photoId, isLike: !isLike) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showLikeTapError()
            }
        }
    }
}
