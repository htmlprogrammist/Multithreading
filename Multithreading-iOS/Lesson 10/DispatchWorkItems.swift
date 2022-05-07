//
//  DispatchWorkItem1.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

class DispatchWorkItem1 {
    private let queue = DispatchQueue(label: "DispatchWorkItem1", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            print("Start in \(Thread.current)")
        }
        
        workItem.notify(queue: .main) { // задаём нотификацию
            print("Finish in \(Thread.current)")
        }
        
        queue.async(execute: workItem)
    }
}

// создадим класс, в котором мы отменим наш workItem
class DispatchWorkItem2 {
    private let queue = DispatchQueue(label: "DispatchWorkItem1") // теперь будет serial queue
    
    func create() {
        queue.async {
            sleep(1)
            print("Task 1 in \(Thread.current)")
        }
        queue.async {
            sleep(1)
            print("Task 2 in \(Thread.current)")
        }
        
        let workItem = DispatchWorkItem {
            print("Task 3 in \(Thread.current) (work item)")
        }
        
        queue.async(execute: workItem)
        workItem.cancel()
    }
}
