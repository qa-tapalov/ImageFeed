//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 25.03.2024.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func fetchUserData()
    func logout()
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewProtocol?) {
        self.view = view
        addObserver()
    }
    
    func fetchUserData() {
        guard let profile = ProfileService.shared.profileModel else {return}
        guard let profileImageURL = ProfileImageService.shared.avatarURL else {return}
        view?.updateProfileData(model: profile, avatarUrl: profileImageURL)
    }
    
    func logout() {
        ProfileCleanService.shared.logout()
    }
    
    private func addObserver(){
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.fetchUserData()
            }
    }
}
