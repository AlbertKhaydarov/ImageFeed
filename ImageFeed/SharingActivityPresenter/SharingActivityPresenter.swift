//
//  SharingImagePresenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 20.10.2023.
//

import UIKit

final class SharingActivityPresenter: SharingActivityPresenterProtocol {
    
    weak var delegate: SharingActivityPresenterDelegate?
    
    init(delegate: SharingActivityPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showSharingActivity(activityItems: [UIImage?], on viewController: UIViewController) {
        
        let sharingActivityViewController = UIActivityViewController(activityItems: activityItems,  applicationActivities: nil)
        
        viewController.present(sharingActivityViewController, animated: true, completion: nil)
    }
}

