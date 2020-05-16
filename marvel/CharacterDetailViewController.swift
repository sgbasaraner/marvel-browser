//
//  CharacterDetailViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    var character: MarvelCharacter!
    private var viewModel: CharacterDetailViewModel!
    
    static let storyboardId = "detailVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        nameLabel?.text = character.name
        descriptionLabel?.text = character.resultDescription
        if let url = URL(string: character.thumbnail.urlString) {
            imageView?.kf.setImage(with: url)
        }
        viewModel = CharacterDetailViewModel(delegate: self, pageSize: 10, character: character)
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
        presentAlert(text: reason)
    }
}

extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.totalFetchableItemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComicTableViewCell.reuseId) as? ComicTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.item(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
