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
