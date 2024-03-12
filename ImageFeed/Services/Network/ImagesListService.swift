//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 06.03.2024.
//

import Foundation

final class ImagesListService {
    private var lastLoadedPage = 0
    private var task: URLSessionTask?
    static var shared = ImagesListService()
    private (set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        task?.cancel()
        let nextPage = lastLoadedPage + 1
        lastLoadedPage = nextPage
        
        guard
            let request = createRequest(page: nextPage)
        else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let responce):
                    for photo in responce {
                        let model = self.convertToPhoto(responce: photo)
                        self.photos.append(model)
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["photo" : self.photos as Any])
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    private func createRequest(page: Int) -> URLRequest?{
        guard var urlComponents = URLComponents(string: Constants.urlGETPhotos) else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
        ]
        guard let url = urlComponents.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = OAuth2TokenStorage.shared.token else {return nil}
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func convertToPhoto(responce: PhotoResult) -> Photo {
        let models = Photo(id: responce.id, size: CGSize(width: responce.width, height: responce.height), userName: responce.user.name, welcomeDescription: responce.description, thumbImageURL: responce.urls.thumb, largeImageURL: responce.urls.full, isLiked: responce.likedByUser)
        return models
    }
}
