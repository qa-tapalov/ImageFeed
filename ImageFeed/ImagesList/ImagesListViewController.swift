//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 28.12.2023.
//

import UIKit

protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated()
    func showActivityIndicator()
    func hideActivityIndicator()
}

class ImagesListViewController: UIViewController {
    
    //MARK: - Private properties
    private let tableView = UITableView()
    private var photos: [Photo] = []
    private let imagesListCell = ImagesListCell()
    private let imagesListService = ImagesListService.shared
    
    var presenter: ImagesListViewPresenterProtocol?
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListViewPresenter(view: self)
        presenter?.fetchPhotos()
        setupViews()
    }
    
    private func setupViews(){
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = "TableImagesList"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBlack
        imageListCell.delegate = self
        imagesListCell.configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchPhotos()
        }
    }
}

//MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.modalPresentationStyle = .overFullScreen
        singleImageViewController.modalTransitionStyle = .coverVertical
        
        let imageUrl = photos[indexPath.row].largeImageURL
        singleImageViewController.imageUrl = imageUrl
        present(singleImageViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let heightCell = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
        return heightCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = imagesListService.photos[indexPath.row]
        presenter?.changeLike(photoId: photo.id, isLike: photo.isLiked, cell: cell)
    }
}

extension ImagesListViewController: ImagesListViewProtocol {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    func showActivityIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }

}

