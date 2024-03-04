//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 02.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
