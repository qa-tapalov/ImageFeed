//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 01.02.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    var delegate: AuthViewControllerDelegate?
    
    private lazy var authScreenLogo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .authScreenLogo)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonLogIn: UIButton = {
        let view = UIButton()
        view.backgroundColor = .ypWhite
        view.setTitle("Войти", for: .normal)
        view.setTitleColor(.ypBlack, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 17)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupConstraintsAuthScreenLogo(){
        NSLayoutConstraint.activate([
            authScreenLogo.widthAnchor.constraint(equalToConstant: 60),
            authScreenLogo.heightAnchor.constraint(equalToConstant: 60),
            authScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraintsButtonLogIn(){
        NSLayoutConstraint.activate([
            buttonLogIn.heightAnchor.constraint(equalToConstant: 48),
            buttonLogIn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonLogIn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonLogIn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    private func setupViews(){
        view.addSubview(authScreenLogo)
        view.addSubview(buttonLogIn)
        setupConstraintsAuthScreenLogo()
        setupConstraintsButtonLogIn()
        setupButtonAction()
    }
    
    private func setupButtonAction(){
        self.buttonLogIn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        let viewController = WebViewViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
