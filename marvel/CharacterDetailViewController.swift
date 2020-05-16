//
//  CharacterDetailViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    var character: MarvelCharacter!
    var viewModel: CharacterDetailViewModel!
    
    static let storyboardId = "detailVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CharacterDetailViewModel(delegate: self, pageSize: 30, character: character)
        viewModel.fetchItems()
    }
}
extension CharacterDetailViewController: PrefetchingViewModelDelegate {
    func fetchedItems(type: FetchType) {
        DispatchQueue.main.async {
            switch type {
            case .firstFetch:
                self.tableView.reloadData()
            case .nonFirstFetch(indexPathsToReload: let indexPaths):
                let visibleIndexPaths = self.tableView.indexPathsForVisibleRows ?? []
                let indexPathsToReload = Array(Set(visibleIndexPaths).intersection(indexPaths))
                self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            }
        }
    }

    func fetchFailed(reason: String) {
        // TODO: log errors
        print(reason)
    }
}

extension CharacterDetailViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: { viewModel.item(at: $0.row) == nil }) else { return }
        viewModel.fetchItems()
    }
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalFetchableItemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell() // TODO: initialize correct cell
    }
}
