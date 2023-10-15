//
//  FlickrImageTableViewCell.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import UIKit
import Kingfisher

class FlickrImageTableViewCell: UITableViewCell {
    static let identifier = "FlickrImageTableViewCell"

    private let flickrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    
    private let imageTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageTitleLabelContainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.brown
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    
    let gradientLayer: CAGradientLayer = {
          let layer = CAGradientLayer()
          layer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
          ]
          return layer
      }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        config(nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(flickrImageView)

        contentView.backgroundColor = .white
        contentView.layer.addSublayer(gradientLayer)

        gradientLayer.frame = contentView.bounds


        contentView.addSubview(imageTitleLabelContainer)
        imageTitleLabelContainer.addSubview(imageTitleLabel)

        setConstraints()
    }
    
    
    private func setConstraints() {
        let flickrImageViewConstraints = [
            flickrImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            flickrImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            flickrImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            flickrImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            flickrImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            flickrImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -40)

        ]

        let imageTitleLabelConstaints = [
            imageTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            imageTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            imageTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
        ]
        
        let imageTitleLabelContainerConstaints = [
            imageTitleLabelContainer.leadingAnchor.constraint(equalTo: imageTitleLabel.leadingAnchor, constant: -3),
            imageTitleLabelContainer.trailingAnchor.constraint(equalTo: imageTitleLabel.trailingAnchor, constant: 10),
            imageTitleLabelContainer.heightAnchor.constraint(equalTo: imageTitleLabel.heightAnchor, constant: 10),
            imageTitleLabelContainer.bottomAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: 3)
        ]

        NSLayoutConstraint.activate(flickrImageViewConstraints)
        NSLayoutConstraint.activate(imageTitleLabelConstaints)
        NSLayoutConstraint.activate(imageTitleLabelContainerConstaints)
        
    }
    
    func config(_ dataItem: FeederDataItem?) {
        guard let dataItem else {
            imageTitleLabel.text = ""
            flickrImageView.image = nil
            flickrImageView.kf.cancelDownloadTask()
            return
        }

        if let imageData = dataItem.imageData {
            flickrImageView.image = UIImage(data: imageData)
        }

        if let url = URL(string: dataItem.imageURL) {
            flickrImageView.kf.setImage(with: url)
        }
        if !dataItem.title.isEmpty {
            imageTitleLabel.text = dataItem.title
        } else {
            imageTitleLabelContainer.isHidden = true
            imageTitleLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds

    }
}
