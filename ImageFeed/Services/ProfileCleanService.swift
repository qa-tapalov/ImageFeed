//
//  ProfileCleanService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 15.03.2024.
//

import Foundation
import WebKit

final class ProfileCleanService {
    static let shared = ProfileCleanService()
    
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanData()
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanData(){
        OAuth2TokenStorage.shared.deleteToken()
        ImagesListService.shared.removeData()
        ProfileService.shared.removeData()
        ProfileImageService.shared.removeData()
    }
}

