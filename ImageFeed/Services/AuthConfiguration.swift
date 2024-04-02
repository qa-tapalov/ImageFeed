//
//  Constants.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 01.02.2024.
//

import Foundation

enum Constants {
    static let appId = "561502"
    static let accessKey = "tdhj5eEkvMzTWFFJOtv3dTFP-fbjdp6DB9jw-CG25cY"
    static let secretKey = "MWSB9yECW-_Dz47_Stojyw16yEYEleYX7_MT8dxcfhs"
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = "https://api.unsplash.com"
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlFetchToken = "https://unsplash.com/oauth/token"
    static let urlGETProfile = defaultBaseUrl + "/me"
    static let urlGETUserInfo = defaultBaseUrl + "/users/"
    static let urlGETPhotos = defaultBaseUrl + "/photos"
    static let urlChangeLike = defaultBaseUrl + "/photos/id/like"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectUri: String
    let accessScope: String
    let defaultBaseUrl: String
    let authUrlString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectUri: String,
         accessScope: String,
         defaultBaseUrl: String,
         authUrlString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectUri = redirectUri
        self.accessScope = accessScope
        self.defaultBaseUrl = defaultBaseUrl
        self.authUrlString = authUrlString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectUri: Constants.redirectUri,
                                 accessScope: Constants.accessScope,
                                 defaultBaseUrl: Constants.defaultBaseUrl,
                                 authUrlString: Constants.authorizeURLString)
    }
}
