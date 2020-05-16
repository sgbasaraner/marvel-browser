//
//  CharactersViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class CharactersViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MarvelClient.shared.requestCharacters(limit: 10, offset: 0) { (result) in
            print(result)
        }
        // Do any additional setup after loading the view.
    }
}

//extension CharactersViewController: UICollectionViewDelegateFlowLayout {
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        characters.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView
//            .dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId,
//                                 for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
//        let character = characters[indexPath.row]
//        cell.configure(name: character.name, imageUrl: character.imageUrl)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
//        return CGSize(width: itemSize, height: itemSize)
//    }
//}
