//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit
import WebKit


final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
//    private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AuthConsts.accessKey),
//            URLQueryItem(name: "redirect_uri", value: AuthConsts.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AuthConsts.accessScope)
//        ]
//        let url = urlComponents.url!
//        let request = URLRequest(url: url)
//        
//        webView.load(request)
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
//                 self.updateProgress()
             })

//        updateProgress()
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
//    MARK: - catch code from navigationAction
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
