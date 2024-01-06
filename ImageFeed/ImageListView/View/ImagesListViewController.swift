//
//  ViewController.swift
//  ImageFeed
//
//  Created by Admin on 06.10.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorAlertPresenterProtocol?
    
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
        
        presenter = ImagesListPresenter(viewController: self)
        errorPresenter = ErrorAlertPresenter(delegate: self)
        
        view.addSubview(loaderIndicatorBackImageView)
        loaderIndicatorBackImageView.addSubview(loaderIndicator)
        loaderIndicator.translatesAutoresizingMaskIntoConstraints = false
        layoutSetup()
        
        let indicator = MyKFIndicator(view: loaderIndicator)
        indicator.view.tintColor = .ypBlack
        indicator.startAnimatingView()
        
        presenter?.getNotification()
        presenter?.fetchPhotosNextPage()
    }
    
    //MARK: - use for tests
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.viewController = self
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
    func updateTableViewAnimated() {
        let currentPhotosCount = presenter?.photos.count
        let newPhotosCount = presenter?.getPhotosService().count
        if let photos = presenter?.getPhotosService() {
            presenter?.photos = photos
        }
        if let newPhotosCount = newPhotosCount, let currentPhotosCount = currentPhotosCount, currentPhotosCount != newPhotosCount {
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
            viewController.fullImageUrlString = presenter?.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let stringUrl = presenter?.photos[indexPath.row].thumbImageURL else {return}
        let url = URL(string: stringUrl)
        let imageView = cell.imageForCell
        
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Stub")) { _ in            self.loaderIndicatorBackImageView.isHidden = true
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let date = presenter?.photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let isLiked = presenter?.photos[indexPath.row].isLiked{
            cell.setIsLiked(isLiked: isLiked)
        }
    }
    
    private func calculateHeigthCell(for indexPath: IndexPath) -> CGFloat {
        var heightForCell: CGFloat = 0
        if let photo = presenter?.photos[indexPath.row] {
            let image = photo
            let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            heightForCell = image.size.height * (imageViewWidth / (image.size.width)) + imageInsets.top + imageInsets.bottom
        }
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
        var photosCount: Int = 0
        if let presenter = presenter {
            photosCount = presenter.photos.count
        }
        return photosCount
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
        
        // MARK: - disable pagination for UI test (ImageFeedUIlikedTests)
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        if testMode {
          print(presenter?.photos.count)
        } else {
            if indexPath.row + 1 == presenter?.photos.count {
                presenter?.fetchPhotosNextPage()
            }
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
        guard let indexPath = tableView.indexPath(for: cell),
              let presenter = self.presenter
        else { return }
        presenter.changeLikeService(cell, indexPath: indexPath)
    }
}
