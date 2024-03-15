//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 26.02.2024.
//

import Foundation

final class ProfileImageService {
    
    static var shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let session = URLSession.shared
    private (set) var avatarURL: String?
    
    private init(){}
    
    func fetchProfileImageUrl(userName: String, complition: @escaping (Result<String, Error>) -> Void) {
        guard
            let request = createRequest(userName: userName)
        else {
            complition(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResponce, Error>) in
            
            guard let self = self else {return}
            switch result {
            case .success(let responce):
                complition(.success(responce.profileImage.small))
                avatarURL = responce.profileImage.large
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL" : self.avatarURL as Any])
                
            case .failure(let error):
                print("[dataTask]: ProfileImageService -\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func createRequest(userName: String) -> URLRequest? {
        guard let url = URL(string: Constants.urlGETUserInfo + userName) else {assertionFailure("Failed to create URL")
            return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = OAuth2TokenStorage.shared.token else {return nil}
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func removeData(){
        avatarURL = nil
    }
}
