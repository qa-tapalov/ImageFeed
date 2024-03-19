//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.frame = .init(x: 0, y: 0, width: 70, height: 70)
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var userName: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        view.numberOfLines = 0
        view.textColor = UIColor.ypWhite
        return view
    }()
    
    private lazy var loginName: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.ypGray
        return view
    }()
    
    private lazy var userDescription: UILabel = {
        let view = UILabel()
        view.numberOfLines = 10
        view.textAlignment = .justified
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.textColor = UIColor.ypWhite
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
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
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
        vStack.addArrangedSubview(loginName)
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
            userAvatar.heightAnchor.constraint(equalToConstant: 70),
            
        ])
    }
    
    private func setupViews(){
        view.backgroundColor = UIColor.ypBlack
        view.addSubview(vStack)
        setupHorizontalStackView()
        setupVerticalStackView()
        setupConstraits()
        buttonLogOutAction()
        updateLabel()
    }
    
    private func buttonLogOutAction(){
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    @objc func logOut(){
        let alert = UIAlertController(title: "Пока-пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: " Да", style: .default) { _ in
            ProfileCleanService.shared.logout()
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = SplashViewController()
        }
        let actionCancel = UIAlertAction(title: "Нет", style: .cancel) { _ in }
        alert.addAction(actionCancel)
        alert.addAction(actionConfirm)
        present(alert, animated: true)
    }
    
}

extension ProfileViewController {
    private func updateLabel(){
        guard let profile = ProfileService.shared.profileModel else {return}
        userName.text = profile.nameLabel
        loginName.text = "@" + profile.loginNameLabel
        userDescription.text = profile.descriptionLabel
    }
    
    private func updateAvatar() {
        
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
                
        else { return}
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        userAvatar.kf.setImage(with: url,
                               placeholder: UIImage(resource: .placeholder),
                               options: [.processor(processor)])
    }
}
