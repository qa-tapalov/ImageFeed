//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation

final class OAuth2Service {
    
    enum NetworkError: Error {
        case codeError
    }
    
    static let shared = OAuth2Service()
    let url = "https://unsplash.com/oauth/token"
    private let decoder = JSONDecoder()
    private init() {}
    
    func fetchAuthToken(_ code: String, complition: @escaping (Result<String, Error>) -> Void){
        let parameters: [String: Any] = ["client_id": Constants.accessKey,
                                         "client_secret": Constants.secretKey,
                                         "redirect_uri": Constants.redirectUri,
                                         "code": code,
                                         "grant_type": "authorization_code"]
        
        
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error as NSError {
            print(error.localizedDescription)
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
                let result = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                complition(.success(result.accessToken))
            } catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
}

