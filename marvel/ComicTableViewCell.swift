//
//  ComicTableViewCell.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class ComicTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    static let reuseId = "comicCell"
    
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
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with comic: Comic?) {
        if let comic = comic {
            activityIndicator?.stopAnimating()
            nameLabel?.alpha = 1
            nameLabel?.text = comic.title
            if let url = URL(string: comic.thumbnail.urlString) {
                thumbnailImageView?.alpha = 1
                thumbnailImageView?.kf.setImage(with: url)
            }
        } else {
            nameLabel?.alpha = 0
            thumbnailImageView?.alpha = 0
            activityIndicator?.startAnimating()
        }
    }
}
