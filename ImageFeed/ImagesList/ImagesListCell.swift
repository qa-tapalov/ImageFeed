//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 01.01.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - Name cell
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    //MARK: - lificycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.backgroundColor = .clear
        addGradientToGradientView()
    }
    //MARK: - Private properties
    private func addGradientToGradientView() {
        let gradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).withAlphaComponent(0).cgColor
        let colorBottom = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        
    }
}
