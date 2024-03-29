//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 24.02.2024.
//

import Foundation

struct ProfileResponse: Codable {
    
    let id: String
    let username, name, firstName: String
    let lastName: String?
    let bio: String?
    
}
