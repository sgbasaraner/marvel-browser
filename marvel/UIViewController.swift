//
//  UIViewController.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(text: String) {
        let alert = UIAlertController(title: "Oops...", message: text, preferredStyle: .alert)
        let button = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(button)
        alert.overrideUserInterfaceStyle = .dark
        present(alert, animated: true, completion:nil)
    }
}
