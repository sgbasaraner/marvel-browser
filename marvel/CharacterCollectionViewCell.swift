//
//  CharacterCollectionViewCell.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    static let reuseId = "characterCell"
    
    func configure(name: String, imageUrl: String) {
        nameLabel?.text = name
    }
    
    func configureLoading() {
        nameLabel?.text = "LOADING"
    }
}
