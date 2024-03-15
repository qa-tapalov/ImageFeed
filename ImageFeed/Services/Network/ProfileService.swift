//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 24.02.2024.
//

import Foundation

final class ProfileService {
    
    let session = URLSession.shared
    static let shared = ProfileService()
    private(set) var profileModel: ProfileModel?
    private init() {}
    
    func fetchProfile(token: String, complition: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let request = try? createRequest(token: token) else {return}
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResponse, Error>) in
            
            guard let self = self else {return}
            switch result {
            case .success(let response):
                let profileModel = ProfileModel(nameLabel: response.name, loginNameLabel: response.username, descriptionLabel: response.bio)
                self.profileModel = profileModel
                complition(.success(profileModel))
            case .failure(let error):
                complition(.failure(error))
                print("[objectTask]: ProfileService - \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func createRequest(token: String) throws ->  URLRequest? {
        guard let url = URL(string: Constants.urlGETProfile) else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func removeData(){
        profileModel = nil
    }
}
