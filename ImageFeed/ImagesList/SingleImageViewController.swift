//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var imageUrl = ""
    
    //MARK: - Private properties
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.setImage(.navBackButtonWhite, for: .normal)
        view.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var shareButton: UIButton = {
        let view = UIButton()
        view.setImage(.shareButton, for: .normal)
        view.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showImage()
    }
    
    private func showImage(){
        UIBlockingProgressHUD.show()
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url, placeholder: UIImage(resource: .stub)) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {return}
            switch result {
            case .success:
                break
            case .failure(let error):
                self.showError()
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.showImage()
        }
        let actionCancel = UIAlertAction(title: "Не надо", style: .cancel) { [weak self] _ in
            guard let self else {return}
            self.dismiss(animated: true)}
        alert.addAction(actionCancel)
        alert.addAction(actionConfirm)
        
        present(alert, animated: true)
    }
    
    //MARK: - Private methods
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton() {
        guard let image = imageView.image else {return}
        
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func setupScrollView(){
        view.backgroundColor = .ypBlack
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    private func setupViews(){
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        setupScrollView()
        setupConstraits()
    }
    
    private func setupConstraits(){
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -51),
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    @objc private func handleDoubleTap(_ sender: UIGestureRecognizer) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            scrollView.setZoomScale(scrollView.zoomScale + 2, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
}
