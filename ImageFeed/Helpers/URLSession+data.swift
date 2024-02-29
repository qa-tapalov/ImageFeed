//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 28.02.2024.
//

import Foundation

enum NetworkError: Error {  // 1
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            
            switch result {
            case .success(let data):
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                }
            case .failure(let error):
                completion(.failure(error))
                print("[dataTask]: DataError - \(error.localizedDescription)")
                
            }
        }
        return task
    }
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in  // 2
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data)) // 3
                } else {
                    print("[dataTask]: NetworkError - status code: \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode))) // 4
                }
            } else if let error = error {
                print("[dataTask]: NetworkError - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error))) // 5
            } else {
                print("[dataTask]: NetworkError - \(String(describing: error?.localizedDescription))")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError)) // 6
            }
        })
        
        return task
    }
}
