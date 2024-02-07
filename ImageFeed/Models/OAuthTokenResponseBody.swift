//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken, tokenType, scope, username: String
    let createdAt, userId: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
        case userId = "user_id"
        case username
    }
}
