//
//  main.swift
//  multithreading
//
//  Created by Егор Бадмаев on 11.04.2022.
//

import Foundation

/// # The swift developers

/// 1. Thread & Pthread
//unixPosix()
//threadAndPthread()

/// 2. Quality of service
//qosPthread()
//qosNsThread()

/// 3. Synchronisation & Mutex
/* C:
var array = [String]()
var saveThread = SaveThreadC()

saveThread.someMethod {
    print("test")
    array.append("1 thread") // в данном случае наш объект array потокозащищен (до тех пор, пока не будет вызывана функция unlock)
}

array.append("2 thread")
print(array)
*/
/*
var array = [String]()
var saveThread = SaveThread()

saveThread.someMethod {
    print("test")
    array.append("1 thread") // в данном случае наш объект array потокозащищен (до тех пор, пока не будет вызывана функция unlock)
}

array.append("2 thread")
print(array)
*/

/// 4. NSRecursiveLock & Mutex Recursive lock
/*
var recursive = RecursiveMutexTest()
recursive.firstTask() // (Это всё один поток)

var thread = RecursiveThread()
thread.start // start() от класса Thread
*/

/// 5. NSCondition,NSLocking, pthread_cond_t
//NSConditonCCode()
//NSConditionSwiftCode()

/// 15. Operation & OperationQueue & OperationBlock

/// # Вопросы и задачи на iOS-собеседовании
firstMethod()
//secondMethod()
