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
        // TODO: impl
    }
    
    func configure(with character: Character?) {
        if let char = character {
            activityIndicator?.stopAnimating()
            nameLabel?.alpha = 1
            nameLabel?.text = char.name
            if let url = URL(string: char.thumbnail.path + "." + char.thumbnail.thumbnailExtension) {
                imageView?.kf.setImage(with: url)
            }
        } else {
            nameLabel?.alpha = 0
            activityIndicator?.startAnimating()
        }
    }
}
