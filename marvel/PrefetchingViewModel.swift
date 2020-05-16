//
//  PrefetchingViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

protocol PrefetchingViewModel {
    associatedtype Item
    
    init(delegate: PrefetchingViewModelDelegate, pageSize: Int)
    
    var currentItemCount: Int { get }
    var totalFetchableItemCount: Int { get }
    var items: [Item] { get }
    var pageSize: Int { get }
    
    func item(at index: Int) -> Item?
    func fetchItems()
}

extension PrefetchingViewModel {
    var currentItemCount: Int {
        items.count
    }
    
    func item(at index: Int) -> Item? {
        items.nth(index)
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
