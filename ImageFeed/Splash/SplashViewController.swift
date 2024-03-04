//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 05.02.2024.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController{
    
    private let viewController = AuthViewController()
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared
    private var window: UIWindow!
    
    private lazy var launchLogo: UIImageView = {
        let view = UIImageView(image: .launchLogo)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthorization()
    }
    
    private func setupConstraits(){
        NSLayoutConstraint.activate([
            launchLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViews(){
        view.backgroundColor = .ypBlack
        view.addSubview(launchLogo)
        setupConstraits()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    private func checkAuthorization(){
        if OAuth2TokenStorage.shared.hasToken() {
            guard let token = storage.token else {return}
            self.fetchProfile(token: token)
        } else {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = viewController
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code: code)
        }
    }
    
    private func fetchAuthToken(code: String){
        OAuth2Service.shared.fetchAuthToken(code) { [weak self] result in
            
            guard let self = self else {return}
            switch result {
            case .success(let token):
                self.storage.saveToken(token)
                self.fetchProfile(token: token)
            case .failure(let error):
                print(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let userData):
                ProfileImageService.shared.fetchProfileImageUrl(userName: userData.loginNameLabel) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert()
            }
        }
    }
    
    func showAlert(){
        guard let vc = UIApplication.topViewController else {return}
        let alertController = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            vc.navigationController?.dismiss(animated: true)
        }
        alertController.addAction(action)
        vc.present(alertController, animated: true)
    }
}

extension UIApplication {
    static var topViewController: UIViewController? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
    
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentationController {
            return presentedViewController.presentedViewController
        } else {
            return self
        }
    }
}
