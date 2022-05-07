//
//  Semaphore.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

// Семафоры — это блокировки, которые могут быть приобретены более чем одним потоком в зависимости от текущего значения счетчика.
// Мьютекс - блокировщик какого-то ресурса, может работать только с одним потоком, а семафор может работать с 2, 3 и тд (в зависимости от того, сколько мы укажем в счётчике)

// Ининциализация:
let semaphore = DispatchSemaphore(value: 1) // где 1 - количество потоков
// Использовать 0 стоит когда у нас есть потока, которым надо согласовать окончание некоего события. (см. semaphoreTest3())
// Значение > 0 стоит использовать, если у нас есть конечный пул ресурсов, который равен этому передуваемому числу

func semaphoreTest1() {
    let queue = DispatchQueue(label: "SemaphoreQueue", attributes: .concurrent)
    let semaphore = DispatchSemaphore(value: 2) // 2 потока

    queue.async {
        semaphore.wait() // нужно сделать декремент (-1) (2 - 1)
        sleep(3)
        print("Task 1")
        semaphore.signal() // (+1) (1 + 1)
    }
    queue.async {
        semaphore.wait() // нужно сделать декремент (-1)
        sleep(3)
        print("Task 2")
        semaphore.signal() // (+1)
    }
    queue.async {
        semaphore.wait() // нужно сделать декремент (-1)
        sleep(3)
        print("Task 3")
        semaphore.signal() // (+1)
    }
}

func semaphoreTest2() {
    let semaphore = DispatchSemaphore(value: 2)
    // то же самое, что и в semaphoreTest1, только выглядит немного по-другому
    // тоже выводит по 2
    DispatchQueue.concurrentPerform(iterations: 10) { id in
        semaphore.wait()
        sleep(1)
        print("Task \(id)")
        semaphore.signal()
    }
}

func semaphoreTest3() {
    let semaphore = DispatchSemaphore(value: 0)
    // когда передаём 0, нужно вызвать signal() - сделать инкремент
    semaphore.signal()
    
    DispatchQueue.concurrentPerform(iterations: 10) { id in
        semaphore.wait()
        sleep(1)
        print("Task \(id)")
        semaphore.signal()
    }
}

class SemaphoreTest {
    private let semaphore = DispatchSemaphore(value: 2)
    private var array = [Int]()
    
    private func methodWork(_ id: Int) {
        semaphore.wait() // нужно отнять единичку, чтобы синхронизация получилась
        array.append(id)
        print("Array count = \(array.count)")
        
        Thread.sleep(forTimeInterval: 2) // добавил задержку, чтобы визуально было понятно
        semaphore.signal()
    }
    
    public func startAllThread() {
        DispatchQueue.global().async {
            self.methodWork(111)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(123)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(321)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(456)
            print(Thread.current)
        }
        DispatchQueue.global().async {
            self.methodWork(789)
            print(Thread.current)
        }
    }
}
