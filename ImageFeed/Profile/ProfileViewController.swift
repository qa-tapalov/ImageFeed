//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 18.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var userpickPhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func exitButton(_ sender: Any) {
        
    }
}
