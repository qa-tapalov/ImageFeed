//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 06.03.2024.
//

import Foundation

struct UrlsPhoto: Codable {
    let raw, full, regular, small, thumb: String
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsPhoto
}

struct LikeResult: Codable {
    let photo: PhotoResult
}
