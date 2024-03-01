//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "BearerToken"
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
        }
        set {
            guard let value = newValue else {return}
            keychainWrapper.set(value, forKey: tokenKey)
        }
    }
    
    private init(){}
    
    func saveToken(_ token: String) {
        self.token = token
    }
    
    func hasToken() -> Bool {
        token != nil
    }
    
    func deleteToken() {
        keychainWrapper.removeObject(forKey: tokenKey)
    }
}
