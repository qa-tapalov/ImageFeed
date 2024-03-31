//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewProtocol: AnyObject {
    func updateProfileData(model: ProfileModel, avatarUrl: String)
}

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.frame = .init(x: 0, y: 0, width: 70, height: 70)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.accessibilityIdentifier = "userAvatar"
        return view
    }()
    
    private lazy var userName: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        view.numberOfLines = 0
        view.textColor = UIColor.ypWhite
        view.accessibilityIdentifier = "userName"
        return view
    }()
    
    private lazy var userLogin: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.ypGray
        view.accessibilityIdentifier = "userLogin"
        return view
    }()
    
    private lazy var userDescription: UILabel = {
        let view = UILabel()
        view.numberOfLines = 10
        view.textAlignment = .justified
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.ypWhite
        view.accessibilityIdentifier = "userDescription"
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let view = UIButton()
        view.setImage(.logoutButton, for: .normal)
        view.tintColor = UIColor.red
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    var presenter: ProfilePresenterProtocol?
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter = ProfileViewPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchUserData()
    }
    
    //MARK: - Private methods
    private func setupHorizontalStackView(){
        hStack.addArrangedSubview(userAvatar)
        hStack.addArrangedSubview(logoutButton)
        hStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupVerticalStackView(){
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(userName)
        vStack.addArrangedSubview(userLogin)
        vStack.addArrangedSubview(userDescription)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupConstraits(){
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            hStack.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            userAvatar.widthAnchor.constraint(equalToConstant: 70),
            userAvatar.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupViews(){
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(vStack)
        setupHorizontalStackView()
        setupVerticalStackView()
        setupConstraits()
        buttonLogOutAction()
    }
    
    private func buttonLogOutAction(){
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    @objc func logOut(){
        let alert = UIAlertController(title: "Пока-пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "Да", style: .default) { [weak self]_ in
            guard let self else {return}
            self.presenter?.logout()
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = SplashViewController()
        }
        let actionCancel = UIAlertAction(title: "Нет", style: .cancel) { _ in }
        alert.addAction(actionCancel)
        alert.addAction(actionConfirm)
        present(alert, animated: true)
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func updateProfileData(model: ProfileModel, avatarUrl: String) {
        
        self.userName.text = model.nameLabel
        self.userLogin.text = "@" + model.loginNameLabel
        self.userDescription.text = model.descriptionLabel
        guard let url = URL(string: avatarUrl) else { return}
     let processor = RoundCornerImageProcessor(cornerRadius: 35)
     userAvatar.kf.setImage(with: url,
                            placeholder: UIImage(resource: .placeholder),
                            options: [.processor(processor)])
    }
}
