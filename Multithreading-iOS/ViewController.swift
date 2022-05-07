//
//  ViewController.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: nil, message: "Откройте консоль", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
