//
//  CharacterCollectionViewCell.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    
    static let reuseId = "characterCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .white
        nameLabel.layer.shadowOpacity = 1
        nameLabel.layer.shadowRadius = 1
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Marvel-Regular", size: 23)
        contentView.bringSubviewToFront(nameLabel)
    }
    
    private func cleanName(_ name: String) -> String {
        return name.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression)
    }
    
    func configure(with character: MarvelCharacter?) {
        if let char = character {
            activityIndicator?.stopAnimating()
            nameLabel?.alpha = 1
            nameLabel?.text = cleanName(char.name.uppercased())
            if let url = URL(string: char.thumbnail.urlString) {
                imageView?.alpha = 1
                imageView?.kf.setImage(with: url)
            }
        } else {
            nameLabel?.alpha = 0
            imageView?.alpha = 0
            activityIndicator?.startAnimating()
        }
    }
}
