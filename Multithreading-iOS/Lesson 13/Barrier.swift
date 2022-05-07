//
//  Barrier.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

// Barrier - Cause the work item to act as a barrier block when submitted to a concurrent queue.
// Барьер - Заставляет work item действовать как блок барьера при отправке в параллельную очередь.

// Барьер дожидается, когда закончатся выполняться какие-то таски, а затем выполнится барьер - например, запись в БД
// После того, как запись произошла (барьер закончил свою работу), дальше начинаются выполняться следующие таски

// То есть Barrier - это некий блок, который блокирует на время записи, например, очередь, и не пускает параллельное выполнение каких-то задач

func raceConditionInBarrier() {
    var array = [Int]()
    
    DispatchQueue.concurrentPerform(iterations: 10) { index in
        array.append(index)
    }
    print(array) // [0] или [1] или [2, 8] и тд. Крч race-condition
}

func testBarrier() {
    let safeArray = SafeArray<Int>()
    
    DispatchQueue.concurrentPerform(iterations: 10) { index in
        safeArray.append(index)
    }
    print(safeArray.valueArray) // [1, 5, 0, 8, 7, 2, 3, 9, 6, 4] - правильный вывод
    // Таким образом, мы барьером защитили и запись, и чтение
    // Барьером можно защищать критические секции, и вообще что угодно, используя этот флаг
}

class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "SafeArray", attributes: .concurrent)
    
    // публичный метод, через который мы будем всё добавлять
    // защищаем запись
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    // защищаем чтение
    public var valueArray: [T] {
        var result = [T]()
        queue.sync { // если мы напишем Асинхронно, работать не будет. Мы дожидаемся окончания, и после этого только начинаем показывать наш массив
            result = self.array
        }
        return result
    }
}
