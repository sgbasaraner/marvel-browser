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
        viewModel = CharactersViewModel(delegate: self, pageSize: 30)
        viewModel.fetchItems()
    }
}

extension CharactersViewController: PrefetchingViewModelDelegate {
    func fetchedItems(type: FetchType) {
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.totalFetchableItemCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId,
                                 for: indexPath) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.item(at: indexPath.row))
        return cell
    }
    
    func fetchFailed(reason: String) {
        // TODO: log errors
        print(reason)
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.invalidateLayout()
        let edgeLength = (self.view.frame.width / 2) - 6
        return CGSize(width: edgeLength, height: edgeLength)
    }
}

extension CharactersViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { viewModel.item(at: $0.row) == nil }) else { return }
        viewModel.fetchItems()
    }
}
