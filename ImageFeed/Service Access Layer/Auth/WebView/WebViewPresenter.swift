//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 24.12.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
//        var urlComponents = URLComponents(string: AuthConfiguration.standard.authURLString)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AuthConfiguration.standard.accessKey),
//            URLQueryItem(name: "redirect_uri", value: AuthConfiguration.standard.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AuthConfiguration.standard.accessScope)
//        ]
//        //        let url = urlComponents.url!
//        guard let url = urlComponents.url else {
//            assertionFailure("Failed to create full URL \(NetworkError.invalidURL)", file: #file, line: #line)
//            return}
        
//        let request = URLRequest(url: url)
        
        let request = authHelper.authRequest()
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    //MARK: - catch code from url 
    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: {$0.name == "code"})
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        authHelper.code(from: url)
    }
}

