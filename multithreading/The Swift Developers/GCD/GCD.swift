//
//  GCD.swift
//  multithreading
//
//  Created by Егор Бадмаев on 03.05.2022.
//

import Foundation

// Немного теории, чтобы понять, как это работает


class QueueTest1 {
    // создаём свою serial очередь
    private let serialQueue = DispatchQueue(label: "serialTest")
    // создаём свою concurrent очередь
    private let concurrentQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent)
}

class QueueTest2 {
    private let globalQueue = DispatchQueue.global()
    private let mainQueue = DispatchQueue.main
}
