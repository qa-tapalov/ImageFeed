//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 06.03.2024.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    func changeLike(photoId: String, isLike: Bool, complition: @escaping (Result<Photo, Error>) -> Void)
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    private var lastLoadedPage = 0
    private var task: URLSessionTask?
    static var shared = ImagesListService()
    private (set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private init(){}
    
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
                    print("[dataTask]: ImagesListService -\(error.localizedDescription)")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, complition: @escaping (Result<Photo, Error>) -> Void){
        guard let request = createRequestLike(id: photoId, isLike: isLike) else {return}
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            switch result {
            case .failure(let error):
                complition(.failure(error))
            case .success(let response):
                let newPhoto = convertToPhoto(responce: response.photo)
                let index = self.photos.firstIndex(where: { $0.id == photoId })
                guard let index else { return }
                DispatchQueue.main.async {
                    self.photos[index] = newPhoto
                }
                complition(.success(newPhoto))
            }
        }
        task.resume()
    }
    
    private func createRequest(page: Int) -> URLRequest?{
        guard var urlComponents = URLComponents(string: Constants.urlGETPhotos) else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = urlComponents.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = OAuth2TokenStorage.shared.token else {return nil}
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convertToPhoto(responce: PhotoResult) -> Photo {
        let models = Photo(id: responce.id,
                           size: CGSize(width: responce.width, height: responce.height),
                           createdAt: responce.createdAt?.isoDate(),
                           welcomeDescription: responce.description,
                           thumbImageURL: responce.urls.small,
                           largeImageURL: responce.urls.full,
                           isLiked: responce.likedByUser)
        return models
    }
    
    private func createRequestLike(id: String, isLike: Bool)-> URLRequest?{
        let url = Constants.urlChangeLike.replacingOccurrences(of: "id", with: id)
        guard let url = URL(string: url) else {return nil}
        var request = URLRequest(url: url)
        let method = isLike ? HTTPMethod.DELETE.rawValue : HTTPMethod.POST.rawValue
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let token = OAuth2TokenStorage.shared.token else {return nil}
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func removePhotos(){
        photos.removeAll()
    }
}
