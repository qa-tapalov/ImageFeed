//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    //MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        setupScrollView()
    }
    
    //MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        
        guard let image = imageView.image else {return}
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func setupScrollView(){
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
