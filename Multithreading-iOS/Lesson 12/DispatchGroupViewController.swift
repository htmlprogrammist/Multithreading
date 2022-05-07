//
//  DispatchGroupViewController.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

final class DispatchGroupViewController: UIViewController {
    
    let imageUrls = ["https://i0.wp.com/levencovka.ru/wp-content/uploads/2020/07/d5.jpg", // Первая картинка по запросу "Дрифт"
                     "https://phonoteka.org/uploads/posts/2021-04/1618510008_4-p-fon-drift-6.jpg", // Рандом челики
                     "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/170e2b91791745.5e3ade6c98042.jpg", // Дамир и Федор
                     "https://avatars.mds.yandex.net/get-zen_doc/2442582/pub_5f2e7a61e3537762199f33fb_5f313553a54190704e1eea98/scale_1200", // Гоча с Аркашей
                     "https://somanyhorses.ru/wp-content/images/news/avto-novosti/2020/11/zhenskaya-seriya-w-series-stanet-gonkami-podderzhki-formuly-1/5facf4941d547_p.jpg",
                     "https://pokrasymavto.ru/wp-content/uploads/2021/02/c27fefb8b286738f5bff603b3e1a287b-scaled.jpg",
                     "https://cdn.bolgegundem.com/d/news/1042559.jpg",
                     "https://f1tracktalk.com/wp-content/uploads/2020/03/1288431434.jpg"
    ]
    public var imageViews = [UIImageView]()
    
    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupView()
        asyncGroup()
    }
    
    // метод, осуществляющий асинхронную загрузку изображений
    func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> Void) {
        runQueue.async {
            do {
                let data = try Data(contentsOf: imageURL)
                completionQueue.async {
                    completion(UIImage(data: data), nil)
                }
            } catch let error {
                completionQueue.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    // метод, который будет группировать группу асинхронных операций
    func asyncGroup() {
        let group = DispatchGroup()
        
        for i in 0..<imageUrls.count {
            group.enter()
            asyncLoadImage(imageURL: URL(string: imageUrls[i])!,
                           runQueue: .global(),
                           completionQueue: .main) { image, error in
                guard error == nil else { return }
                
                if let image = image {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    self.imagesStackView.addArrangedSubview(imageView)
                }
                group.leave()
            }
        }
        // 30:50
    }
    
    private func setupView() {
        view.addSubview(imagesStackView)
        
        NSLayoutConstraint.activate([
            imagesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesStackView.topAnchor.constraint(equalTo: view.topAnchor),
            imagesStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
