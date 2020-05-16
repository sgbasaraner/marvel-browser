//
//  CharactersViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    
    var viewModel: CharactersViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CharactersViewModel(delegate: self)
        viewModel.fetchCharacters()
    }
}

extension CharactersViewController: CharactersViewModelDelegate {
    func fetchedCharacters(type: FetchType) {
        DispatchQueue.main.async {
            switch type {
            case .firstFetch:
                self.collectionView.reloadData()
            case .nonFirstFetch(indexPathsToReload: let indexPaths):
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                let indexPathsToReload = Array(Set(visibleIndexPaths).intersection(indexPaths))
                self.collectionView.reloadItems(at: indexPathsToReload)
            }
        }
    }
    
    func fetchedCharacters(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
            let indexPathsToReload = Array(Set(visibleIndexPaths).intersection(indexPaths))
            self.collectionView.reloadItems(at: indexPathsToReload)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.totalFetchableCharacterCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId,
                                 for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        if let character = viewModel.character(at: indexPath.row) {
            // TODO: fix img url
            cell.configure(name: character.name, imageUrl: "")
        } else {
            cell.configureLoading()
        }
        return cell
    }
    
    func fetchFailed(reason: String) {
        // TODO: log errors
        print(reason)
    }
}

extension CharactersViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.fetchCharacters()
    }
}
