//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "BearerToken"
    private var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
    
    private init(){}
    
    func saveToken(_ token: String) {
        self.token = token
    }
    
    func hasToken() -> Bool {
        token != nil
    }
    
}
