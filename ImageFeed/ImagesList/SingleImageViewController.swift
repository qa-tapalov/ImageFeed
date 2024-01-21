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
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
