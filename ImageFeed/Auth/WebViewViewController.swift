//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Альберт Хайдаров on 07.11.2023.
//

import UIKit
import WebKit


class WebViewViewController: UIViewController {

    @IBOutlet private var webView: WKWebView!
    
  private let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),
           URLQueryItem(name: "redirect_uri", value: RedirectURI),
           URLQueryItem(name: "response_type", value: "code"),
           URLQueryItem(name: "scope", value: AccessScope)
         ]
         let url = urlComponents.url!
       
        let request = URLRequest(url: url)
 
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
