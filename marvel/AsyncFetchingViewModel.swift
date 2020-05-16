//
//  PrefetchingViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

protocol AsyncFetchingViewModel {
    associatedtype Item
    
    var currentItemCount: Int { get }
    var totalFetchableItemCount: Int { get }
    var items: [Item] { get }
    var pageSize: Int { get }
    
    func item(at index: Int) -> Item?
    func fetchItems()
}

extension AsyncFetchingViewModel {
    var currentItemCount: Int {
        items.count
    }
    
    func item(at index: Int) -> Item? {
        items.nth(index)
    }
    
    var lastPageIndexPaths: [IndexPath] {
        let startIndex = items.count - pageSize
        let endIndex = items.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

enum FetchType {
    case firstFetch
    case nonFirstFetch(indexPathsToReload: [IndexPath])
}

protocol PrefetchingViewModelDelegate: class {
    func fetchedItems(type: FetchType)
    func fetchFailed(reason: String)
}
