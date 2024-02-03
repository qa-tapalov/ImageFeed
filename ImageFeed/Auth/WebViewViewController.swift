//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 01.02.2024.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private let authorizeURLString = "https://unsplash.com/oauth/authorize"
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var navBackButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(resource: .navBackButtonBlack), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .ypBackground
        view.progress = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createAuthUrl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeObserver(self, 
                               forKeyPath: #keyPath(WKWebView.estimatedProgress),
                               context: nil)
    }
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    private func createAuthUrl(){
        var urlComponents = URLComponents(string: authorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
   

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupConstraitsWebView(){
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupConstraitsBackButton(){
        NSLayoutConstraint.activate([
            navBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            navBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBackButton.widthAnchor.constraint(equalToConstant: 30),
            navBackButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupConstraitsProgressView(){
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: navBackButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupButtonAction(){
        self.navBackButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
    }
    
    private func setupViews(){
        view.addSubview(webView)
        view.addSubview(navBackButton)
        view.addSubview(progressView)
        setupConstraitsWebView()
        setupConstraitsBackButton()
        setupConstraitsProgressView()
        setupButtonAction()
        webView.navigationDelegate = self
    }
    
    @objc func tapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
        print("tapped")
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            //TODO:
            decisionHandler(.cancel)
        } else {
            
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
}
