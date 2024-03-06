//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 03.02.2024.
//

import Foundation

final class OAuth2Service {
    
    enum AuthServiceError: Error {
        case requestError
    }
    
    private var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()
    private let session = URLSession.shared
    private init() {}
    
    func fetchAuthToken(_ code: String, complition: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        
        guard lastCode != code
        else {
            complition(.failure(AuthServiceError.requestError))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard
            let request = createOAuthTokenRequest(code: code)
        else {
            complition(.failure(AuthServiceError.requestError))
            return
        }
        
        let task = session.objectTask(for: request) {(result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let response):
                complition(.success(response.accessToken))
            case .failure(let error):
                print("[objectTask]: OAuth2Service - \(error.localizedDescription)")
                complition(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func createOAuthTokenRequest(code: String) -> URLRequest? {
        let parameters: [String: Any] = ["client_id": Constants.accessKey,
                                         "client_secret": Constants.secretKey,
                                         "redirect_uri": Constants.redirectUri,
                                         "code": code,
                                         "grant_type": "authorization_code"]
        
        
        guard let url = URL(string: Constants.urlFetchToken) else {assertionFailure("Failed to create URL")
            return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return request
    }
    
}

