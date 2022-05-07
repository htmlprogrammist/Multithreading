//
//  SecondViewController.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Second"
        
        print(Thread.isMainThread) // можно как-то с этим поиграться, делать if-else какой-нибудь
        
//        experiment()
        myInactiveQueue()
    }
    
    private func experiment() {
        /*for i in 0..<200000 {
            print(i)
        }*/
        
        // разбили на несколько потоков, хорошо. Но всё ещё блокируется UI (main поток)
        /*DispatchQueue.concurrentPerform(iterations: 200000) { i in
            print(Thread.current)
        }*/
        
        // Сделаем так, чтобы main поток не был задействован
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            // concurrentPerform работает намного быстрее цикла + параллельно => идеально подходит для итераций
            DispatchQueue.concurrentPerform(iterations: 200000) { i in
                print(Thread.current)
            }
        }
    }
    
    // управляемая очередь
    private func myInactiveQueue() {
        // если не использовать attributes, то очередь будет .serial
        let inactiveQueue = DispatchQueue(label: "inactiveQueue", attributes: [.concurrent, .initiallyInactive])
        inactiveQueue.async {
            print("Done \(Thread.current)")
        }
        print("Not started yet")
        inactiveQueue.activate() // проснись
        print("After activate()")
        inactiveQueue.suspend() // постой
        print("After suspend()")
        inactiveQueue.resume()
        print("After resume()")
        /* Output:
         Not started yet
         After activate()
         After suspend()
         After resume()
         Done <NSThread: 0x6000005b9bc0>{number = 7, name = (null)}
         */
    }
}
