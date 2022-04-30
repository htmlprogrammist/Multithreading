//
//  NSRecursiveLock & Mutex Recursive lock.swift
//  multithreading
//
//  Created by Егор Бадмаев on 18.04.2022.
//

import Foundation

// NSLock
// Этот класс хорош, но мы не должны использовать этот класс для реализации рекурсивной блокировки, чтобы наш поток не заблокировался насвегда (dead-lock)
// Рекурсивно - вызываем один метод, ставим блокировку, у этого метода внутри вызывается другой метод, который тоже ставит блокировку.
// И тогда один метод блокирует другой и происходит голодание (starvation) (поток не может получить доступ к ресурсу и пытается снова и снова получить доступ к ресурсу)

// C:

class RecursiveMutexTest {
    private var mutex = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribute)
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)
        // Сейчас "Finish" появится в консоли, но если поменять атрибут PTHREAD_MUTEX_RECURSIVE на какой-нибудь другой, то "Финиша" мы уже не увидим
        
        pthread_mutex_init(&mutex, &attribute)
    }
    
    // рекурсивно не будем создавать, создадим 2 метода, в которых один вызывает другой
    public func firstTask() {
        
        pthread_mutex_lock(&mutex)
        
        defer { // при завершении этого метода обязательно произойдёт unlock
            pthread_mutex_unlock(&mutex)
        }
        
        secondTask()
    }
    
    private func secondTask() {
        
        pthread_mutex_lock(&mutex)
        
        defer { // при завершении этого метода обязательно произойдёт unlock
            pthread_mutex_unlock(&mutex)
        }
        
        print("Finish")
        
        
    }
}

// пишем то же самое, но уже на Swift/Objective-C
let recursiveLock = NSRecursiveLock()

class RecursiveThread: Thread {
    
    override func main() {
        recursiveLock.lock()
        print("Thread acquired lock (замок сработал)")
        
        callMe()
        
        defer {
            recursiveLock.unlock()
        }
        print("Exit main")
    }
    
    private func callMe() { // secondTask
        recursiveLock.lock()
        
        defer {
            recursiveLock.unlock()
        }
        
        print("Exit callMe")
    }
}
