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
    
    let fullImage: String? = nil
    
    var sharingActivityPresenter: SharingActivityPresenterProtocol?
    
    //MARK: -  add ErrorPresenter
    var errorPresenter: ErrorAlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        imageView.image = image
        
        rescaleAndCenterImageInScrollView(image: image)
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
    private func getSingleImmage(for imageView: UIImageView?) {
        guard let imageView = imageView,
        let url = fullImage
        else {return}
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
        let errorModel = ErrorAlertModel(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: "Ошибка в установке Like",
            buttonText: "Ok")
        { }
        self.errorPresenter?.errorShowAlert(errorMessages: errorModel, on: self)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
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

extension SingleImageViewController: ErrorAlertPresenterDelegate {
    func errorShowAlert() { }
}
