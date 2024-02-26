//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 24.02.2024.
//

import Foundation

final class ProfileService {
    
    enum NetworkError: Error {
        case error
        case codeError
        case failCreateUrl
    }
    
    private let url = Constants.defaultBaseUrl + "/me"
    private let decoder = JSONDecoder()
    static let shared = ProfileService()
    private(set) var profileModel: ProfileModel?
    
    private init() {}
    
    func fetchProfile(token: String, complition: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard
            let request = createRequest(token: token)
        else {
            complition(.failure(NetworkError.failCreateUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                complition(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                return complition(.failure(NetworkError.codeError))
            }
            
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else { return }
            do {
                let result = try self.decoder.decode(ProfileResponse.self, from: data)
                let profileModel = ProfileModel(nameLabel: result.name, loginNameLabel: result.username, descriptionLabel: result.bio)
                self.profileModel = profileModel
                complition(.success(profileModel))
                
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createRequest(token: String) -> URLRequest? {
        guard let url = URL(string: url) else {assertionFailure("Failed to create URL")
            return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}
