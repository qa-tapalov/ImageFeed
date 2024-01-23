//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Тапалов on 01.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - Name cell
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Outlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    
    //MARK: - lificycle
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        addGradientToGradientView()
    }
    
    //MARK: - Private properties
    private func addGradientToGradientView() {
        let gradientLayer = CAGradientLayer()
        let colorTop = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0).withAlphaComponent(0).cgColor
        let colorBottom = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1).withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = String(indexPath.row)
        guard let imageCell = UIImage(named: imageName) else {return}
        cell.imageCell.image = imageCell
        let date = Date()
        cell.dateLabel.text = date.dateFormat
        let likeImage: UIImage!
        
        if indexPath.row % 2 == 0 {
            likeImage = UIImage(named: "likeActive")
        } else {
            likeImage = UIImage(named: "likeNoActive")
        }
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
