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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        view.color = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewDisabled: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewDisabled.isHidden = true
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
    
    private func setupConstraintsActivityIndicator(){
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupConstraitViewDisabled(){
        NSLayoutConstraint.activate([
            viewDisabled.topAnchor.constraint(equalTo: view.topAnchor),
            viewDisabled.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewDisabled.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewDisabled.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func activityIndicatorAnimating(){
        viewDisabled.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorAnimatingStop(){
        viewDisabled.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func setupViews(){
        view.backgroundColor = .ypBlack
        view.addSubview(authScreenLogo)
        view.addSubview(buttonLogIn)
        view.addSubview(viewDisabled)
        view.addSubview(activityIndicator)
        setupConstraintsAuthScreenLogo()
        setupConstraintsButtonLogIn()
        setupConstraintsActivityIndicator()
        setupConstraitViewDisabled()
        setupButtonAction()
    }
    
    private func setupButtonAction(){
        buttonLogIn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
