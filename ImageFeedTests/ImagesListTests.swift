//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Андрей Тапалов on 27.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerSpy: ImagesListViewProtocol {
    var indicatorShowed: Bool = false
    
    func updateTableViewAnimated() {
    }
    
    func showActivityIndicator() {
        indicatorShowed = true
    }
    
    func hideActivityIndicator() {
    }
}

final class ImagesListServiceMock: ImagesListServiceProtocol{
    func fetchPhotosNextPage() {
    }
    
    func changeLike(photoId: String, isLike: Bool, complition: @escaping (Result<ImageFeed.Photo, Error>) -> Void) {
    }
}

final class ImagesListTests: XCTestCase {
    
    func testPresenterCallsShowActivityIndicator(){
        let view = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: view)
        presenter.changeLike(photoId: "", isLike: true, cell: ImagesListCell())
        
        XCTAssertTrue(view.indicatorShowed)
    }
    
    func testPresenterCallsFetchPhotos(){
        let service = ImagesListService.shared
        let view = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter(view: view)
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        presenter.fetchPhotos()
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(service.photos.count, 10)
    }
    
}
