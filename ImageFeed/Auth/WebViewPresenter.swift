//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 19.03.2024.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? {get set}
    func didLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        view?.setProgressValue(Float(newValue))
        view?.setProgressHidden(abs(newValue - 1.0) <= 0.0001)
    }
    
    func didLoad() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
}
