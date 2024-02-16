//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken, tokenType, scope, username: String
    let createdAt, userId: Int
}
