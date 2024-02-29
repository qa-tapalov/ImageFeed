//
//  UserResponce.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 26.02.2024.
//

import Foundation

struct UserResponce: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small, medium, large: String
    }
}




