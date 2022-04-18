//
//  Synchronisation & Mutex.swift
//  multithreading
//
//  Created by Егор Бадмаев on 18.04.2022.
//

import Foundation

// Mutex - защита объекта от доступа к нему из других потоков, отличных от того, который завладел мьютексом
// Только 1 поток может владеть объектом

// Если другому потоку нужен будет доступ к объекту, то он засыпает и ждёт, пока мьютекс не будет освобожден
// Т.е. мьютекс может блокировать и освобождать объекты

class SaveThreadC {
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    // метод, в котором будет производиться блокировка и освобождение объекта
    // передадим этот объект через замыкание
    func someMethod(completion: () -> ()) {
        pthread_mutex_lock(&mutex)
        
        // working with data...
        completion()
        
//        pthread_mutex_unlock(&mutex)
        // Если вдруг что-то упадёт, крякнется, сломается, то наш объект не освободится. Поэтому используем defer - специальный метод, который при несчастном случае освободит наш объект
        defer {
            pthread_mutex_unlock(&mutex)
        }
        // Xcode warning: 'defer' statement at end of scope always executes immediately; replace with 'do' statement to silence this warning
    }
}

class SaveThread {
    private let lockMutex = NSLock()
    // инициализатор нам теперь не нужен. Всё инициализируется выше
    
    func someMethod(completion: () -> ()) {
        lockMutex.lock()
        
        completion()
        
        defer {
            lockMutex.unlock()
        }
    }
}
