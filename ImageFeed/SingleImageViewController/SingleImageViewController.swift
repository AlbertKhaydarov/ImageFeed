//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 19.10.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var sharingButton: UIButton!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var fullImageUrlString: String? = nil
    
    var sharingActivityPresenter: SharingActivityPresenterProtocol?
    
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorPresenterTwoButtonsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        getSingleImage(for: imageView)
        
        sharingActivityPresenter = SharingActivityPresenter(delegate: self)
        errorPresenter = ErrorAlertPresenterTwoButtons(delegate: self)
    }
    
    @IBAction private func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let objectsToShare = [image]
        sharingActivityPresenter?.showSharingActivity(activityItems: objectsToShare, on: self)
    }
    
    //MARK: - Dowload Image
    private func getSingleImage(for imageView: UIImageView?) {
        guard let imageView = imageView,
              let url = fullImageUrlString
        else {
            self.showError()
            return}
        
        let fullImageUrl = URL(string: url)
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    func showError() {
        let errorModel = ErrorTwoButtonsAlertModel(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            hideActionButtonText: "Не надо",
            retryActionButtonText: "Повторить")
        {[weak self] in
            guard let self = self else {return}
            getSingleImage(for: imageView)
        }
        self.errorPresenter?.showErrorAlert(errorMessages: errorModel, on: self)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let visibleRectSize = scrollView.bounds.size
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension SingleImageViewController: SharingActivityPresenterDelegate {
    func finishShowSharing(image: UIImage){
        rescaleAndCenterImageInScrollView(image: image)
    }
}

extension SingleImageViewController: ErrorPresenterTwoButtonsDelegate {
    func showErrorAlert() { }
    func hideErrorViewController(_ errorAlertPresenter: ErrorAlertPresenterTwoButtons) {
        dismiss(animated: true, completion: nil)
    }
}
