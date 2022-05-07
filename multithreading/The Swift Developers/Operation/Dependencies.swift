//
//  Dependencies.swift
//  multithreading
//
//  Created by Егор Бадмаев on 08.05.2022.
//

import Foundation

// Ещё одно ключевое преимущество Operation над GCD - свойство Dependencies (зависимости)
// С помощью зависимостей мы можем определять порядок выполнения наших операций и строить целые цепочки бизнес-логики
// Это очень удобно в случае сложных архитектур

// "Операция 2" начнёт своё выполнение только тогда, когда "операция 1" будет выполнена

func testDependencies() {
    let operationQueue = OperationQueue()
     
    let operation1 = BlockOperation { print("test1") }
    let operation2 = BlockOperation { print("test2") }
    let operation3 = BlockOperation { print("test3") }
     
    operation3.addDependency(operation2) // operation3 не будет выполнен, пока не завершена operation2 (3 будет выполнена после выполнения 2)
     
    operationQueue.addOperations([operation1, operation2, operation3], waitUntilFinished: false)
    /* Output (возможные варианты):
     t2 t1 t3
     t1 t2 t3
     t2 t3 t1
     */
}
