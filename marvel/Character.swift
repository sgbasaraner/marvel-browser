//
//  Character.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

struct Character {
    let name: String
    let imageUrl: String
}

let dummyCharacters: [Character] = (0...20).map { _ in Character(name: randomString(), imageUrl: "") }

func randomString() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<10).map{ _ in letters.randomElement()! })
}
