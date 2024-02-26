//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 25.02.2024.
//

import Foundation

struct ProfileModel {
    let nameLabel: String
    let loginNameLabel: String
    let descriptionLabel: String?
    
    init(nameLabel: String, loginNameLabel: String, descriptionLabel: String?) {
        self.nameLabel = nameLabel
        self.loginNameLabel = "@" + loginNameLabel
        self.descriptionLabel = descriptionLabel
    }
}
