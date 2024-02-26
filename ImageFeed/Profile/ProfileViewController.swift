//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .userpickPhoto)
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
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
        updateLabel()
    }
}

extension ProfileViewController {
    private func updateLabel(){
        guard let profile = ProfileService.shared.profileModel else {return}
        userName.text = profile.nameLabel
        loginName.text = profile.loginNameLabel
        userDescription.text = profile.descriptionLabel
    }
}
