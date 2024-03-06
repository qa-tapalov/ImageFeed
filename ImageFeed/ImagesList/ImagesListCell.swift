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
    
    //MARK: - Private Properties
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    private lazy var imageCell: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - lificycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setupConstraitsImageCell(){
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupConstraitsDateLabel(){
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor)
        ])
    }
    
    private func setupConstraitsLikeButton(){
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupConstraitsGradientView(){
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupViews(){
        contentView.backgroundColor = .clear
        contentView.addSubview(imageCell)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(gradientView)
        addGradientToGradientView()
        setupConstraitsImageCell()
        setupConstraitsLikeButton()
        setupConstraitsDateLabel()
        setupConstraitsGradientView()
    }
    
}
