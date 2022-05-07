//
//  DispatchGroup.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

// DispatchGroup - это очень крутой инструмент
// Если вдруг у нас есть 3-4 схожие задачи, и мы хотим, чтобы сначала выполнились они, а только потом что-то другое, или мы хотим их как-то сгруппировать
// Например, мы хотим загрузить 4 картинки на один экран и только после этого что-то показывать
// Можно объединить их таким классом как DispatchGroup

// 1-й вариант
class DispatchGroupTest1 { // последовательная очередь
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private let group = DispatchGroup()
    
    func loadInfo() {
        serialQueue.async(group: group) {
            sleep(1)
            print("Task 1")
        }
        serialQueue.async(group: group) {
            sleep(1)
            print("Task 2")
        }
        
        // когда все блоки группы отрабатывают, приходит уведомление (notify) и мы переходим в .main поток
        group.notify(queue: .main) {
            print("Finish")
        }
    }
}

// 2-й вариант
class DispatchGroupTest2 { // параллельная очередь
    private let concurrentQueue = DispatchQueue(label: "serialQueue", attributes: .concurrent)
    private let group = DispatchGroup()
    
    func loadInfo() {
        group.enter() // добавь блок кода в нашу группу
        concurrentQueue.async {
            sleep(1)
            print("Task 1")
            self.group.leave() // можно выйти из этого блока
        }
        
        group.enter() // добавь блок кода в нашу группу
        concurrentQueue.async {
            sleep(2)
            print("Task 2")
            self.group.leave() // можно выйти из этого блока
        }
        
        group.wait() // пока не выполнится всё, что есть сверху, мы будем ждать
        
        group.notify(queue: .main) {
            print("Finish")
        }
    }
}
