//
//  CharactersViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    
    private var viewModel: CharactersViewModel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator?.startAnimating()
        viewModel = CharactersViewModel(delegate: self, pageSize: 30)
        viewModel.fetchItems()
        customizeBackButton()
    }
    
    private func customizeBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .gray
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let character = viewModel.item(at: indexPath.row) else { return }
        goToDetails(character: character)
    }
    
    private func goToDetails(character: MarvelCharacter) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: CharacterDetailViewController.storyboardId) as? CharacterDetailViewController else { return }
        vc.character = character
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CharactersViewController: PrefetchingViewModelDelegate {
    func fetchedItems(type: FetchType) {
        DispatchQueue.main.async {
            switch type {
            case .firstFetch:
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            case .nonFirstFetch(indexPathsToReload: let indexPaths):
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                let indexPathsToReload = Array(Set(visibleIndexPaths).intersection(indexPaths))
                self.collectionView.reloadItems(at: indexPathsToReload)
            }
        }
    }
    
    func fetchFailed(reason: String) {
        presentAlert(text: reason)
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
