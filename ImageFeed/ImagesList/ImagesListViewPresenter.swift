//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 26.03.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol: AnyObject {
    func fetchPhotos()
    func changeLike(photoId: String, isLike: Bool, cell: ImagesListCell)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewProtocol?
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewProtocol?) {
        self.view = view
        addObserver()
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, cell: ImagesListCell) {
        view?.showActivityIndicator()
        imagesListService.changeLike(photoId: photoId, isLike: isLike)  { [weak self] result in
            
            guard let self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let newPhoto):
                    cell.setIsliked(isLiked: newPhoto.isLiked)
                    self.view?.hideActivityIndicator()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.view?.hideActivityIndicator()
                }
            }
        }
    }
    
    private func addObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                view?.updateTableViewAnimated()
            }
    }
    
}
