//
//  FirstViewController.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

class FirstViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Forward", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "First"
        
//        afterBlock(seconds: 4, queue: .main) {
//            print(Thread.current)
//        }
        
//        afterBlock(seconds: 2) {
//            print(Thread.current)
//            DispatchQueue.main.async {
//                self.showAlert()
//            }
//        }
        
        setupView()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "\(Thread.current)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> ()) {
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
    
    private func setupView() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    @objc private func goForward() {
        let destination = SecondViewController()
        navigationController?.pushViewController(destination, animated: true)
    }
}
