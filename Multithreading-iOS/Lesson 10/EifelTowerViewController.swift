//
//  EifelTowerViewController.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

class EifelTowerViewController: UIViewController {
    
    /// # Dispatch Work Item
    
    let dispatchWorkItem1 = DispatchWorkItem1()
    let dispatchWorkItem2 = DispatchWorkItem2()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "SwiftPackagerManager")
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    let imageURL = URL(string: "https://www.planetware.com/photos-large/F/eiffel-tower.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        
//        dispatchWorkItem1.create()
//        dispatchWorkItem2.create()
        
        // 3 разными способами получим фотографию Эйфелевой башни
//        getEiffelTowerByClassic() // просто получение
//        getEiffelTowerByDispatchWorkItem() // через work item
//        getEiffelTowerByURLSession() // через URLSession dataTask
    }
    
    private func getEiffelTowerByClassic() {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let data = try? Data(contentsOf: self.imageURL) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func getEiffelTowerByDispatchWorkItem() {
        var data: Data?
        let queue = DispatchQueue.global(qos: .utility)
        
        let workItem = DispatchWorkItem(qos: .userInitiated) { // (1)
            data = try? Data(contentsOf: self.imageURL)
            print(Thread.current)
        }
        
        queue.async(execute: workItem)
        
        // когда наша задача (1) завершится
        workItem.notify(queue: .main) { // ...сработает наш notify
            if let data = data {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getEiffelTowerByURLSession() {
        // Класс URLSession работает асинхронно
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard error == nil else { return }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
    
    private func setupView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
