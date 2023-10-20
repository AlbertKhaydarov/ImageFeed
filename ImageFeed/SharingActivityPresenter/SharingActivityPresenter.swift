//
//  SharingImagePresenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 20.10.2023.
//

import UIKit

class SharingActivityPresenter: SharingActivityPresenterProtocol {
    
    weak var delegate: SharingActivityPresenterDelegate?
    
    init(delegate: SharingActivityPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showSharingActivity(activityItems: [UIImage?], on viewController: UIViewController) {
        let sharingActivityViewController = UIActivityViewController(activityItems: activityItems,  applicationActivities: nil)
        
        sharingActivityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                               UIActivity.ActivityType.copyToPasteboard,
                                                               UIActivity.ActivityType.postToVimeo]
        
        viewController.present(sharingActivityViewController, animated: true, completion: nil)
    }
}

