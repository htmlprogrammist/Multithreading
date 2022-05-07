//
//  DispatchSource.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

// Dispatch Source - представляет интерфейс для мониторинга низкоуровневых системных объектов
// Т.е. системные объекты, такие как mach порты, unix дескрипторы, unix сигналы

// Этот класс позволяет получать уведомления, такие как: файловой системы, можно настроить уведомление так, чтобы оно говорило, что файл изменился как-то, либо сокет-операции (сокет - непрерывный канал между сервером и смартфоном)


func dispatchSourceTest() {
    let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    
    timer.setEventHandler { // когда наш таймер сработает, выполнится некий handler
        print("Handler")
    }
    
    timer.schedule(deadline: .now(), repeating: 5)
    timer.activate()
}
