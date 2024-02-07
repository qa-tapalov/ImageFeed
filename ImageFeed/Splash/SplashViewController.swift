//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 05.02.2024.
//

import UIKit

final class SplashViewController: UIViewController{
    
    let viewController = AuthViewController()
    
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
        
        let tabBarController = storyboard?.instantiateViewController(identifier: "TabBar") as! UITabBarController
        window.rootViewController = tabBarController
    }
    
    private func checkAuthorization(){
        if OAuth2TokenStorage.shared.hasToken() {
            switchToTabBarController()
        } else {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = viewController
        }
        
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            
            guard let self = self else { return }
            self.fetchAuthToken(code: code)
        }
    }
    
    private func fetchAuthToken(code: String){
        OAuth2Service.shared.fetchAuthToken(code) { [weak self] result in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    OAuth2TokenStorage.shared.saveToken(token)
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
