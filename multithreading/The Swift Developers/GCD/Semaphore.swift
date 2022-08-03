//
//  Semaphore.swift
//  multithreading
//
//  Created by Егор Бадмаев on 05.05.2022.
//

import Foundation

private let semaphore = DispatchSemaphore(value: 1)

private let semaphore0 = DispatchSemaphore(value: 0)
// Использовать 0 стоит когда у нас есть потока, которым надо согласовать окончание некоего события.
// Значение > 0 стоит использовать, если у нас есть конечный пул ресурсов, который равен этому передуваемому числу

/*
 Семафоры — это блокировки, которые могут быть приобретены более чем одним потоком в зависимости от текущего значения счетчика.
 
 Потоки ждут на семафоре, когда счетчик, уменьшаемый каждый раз, когда семафор приобретается, достигает нуля.
 
 Доступ к семафору освобождается для ожидающих потоков вызовом signal который увеличивает счетчик.
 
 Давайте посмотрим на простой пример:
 */
func semaphoreTest() {
    let sem = DispatchSemaphore(value: 2)
    // The semaphore will be held by groups of two pool threads globalDefault.sync {
    DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
        sem.wait(timeout: DispatchTime.distantFuture)
        sleep(1)
        print(String(id)+" acquired semaphore.")
        sem.signal()
    }
}
