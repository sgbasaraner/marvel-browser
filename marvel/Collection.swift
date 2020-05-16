//
//  Collection.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

extension Collection {
    func nth(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
