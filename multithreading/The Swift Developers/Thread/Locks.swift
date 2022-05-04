//
//  Locks.swift
//  multithreading
//
//  Created by Егор Бадмаев on 30.04.2022.
//

import Foundation

// ReadWriteLock, SpinLock, UnfairLock, Synchronized in Objc

// Благодаря замкам происходит **синхронизация** потоков

// Замок, похожий на мьютекс, у него тоже Сшная реализация (Foundation нет)
// Он занимается тем, что может оставить нашему проперти только чтение (т.е. защитить наше чтение), защитить геттер или сеттер
// Т.е. он может защищать запись, или чтение, или и то, и другое
class ReadWriteLock {
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init() {
        // инициализируем
        pthread_rwlock_init(&lock, &attribute)
    }
    
    // создаём проперти, мы будем к нему обращаться и этот проперти будет защищен на запись и чтение
    public var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty // к нему и будем обращаться
            // вся работа будет со временной переменной, которая будет заблокирована определённым замком
            pthread_rwlock_unlock(&lock)
            return temp
        }
        set {
            // то же самое, только здесь будет newValue
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}

// SpinLock, который рекомендовали использовать, потому что он гораздо быстрее, чем мьютексы. Но потом что-то пошло не так... И сейчас обсудим, что
class SpinLock {
    // создаём спинлок
    private var lock = OS_SPINLOCK_INIT
    
    func some() {
        OSSpinLockLock(&lock)
        // ...
        OSSpinLockUnlock(&lock)
    }
}

// Вместо спинлока был придуман другой подход, которые быстрее, работает по другому принципу, приоритеты другие

