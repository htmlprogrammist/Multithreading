//
//  BlockOperation.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 08.05.2022.
//

import Foundation

// Отмена операции
// В GCD её можно отменить только тогда, когда она ещё не попала в очередь
// В Operation можно отменять и во время
func cancelOperationMethod() {
    let operationQueue = OperationQueue()
    let cancelOperationTest = OperationCancelTest()
    
    operationQueue.addOperation(cancelOperationTest)
//    sleep(1)
    cancelOperationTest.cancel()
}

class OperationCancelTest: Operation {
    override func main() {
        if isCancelled {
            print(isCancelled)
            return
        }
        print("Test 1")
        sleep(1)
        if isCancelled { // и ещё раз проверим; чтобы мы видели, в какой момент это отменилось
            print(isCancelled)
            return
        }
        print("Test 2")
    }
}

// Аналог Barrier - WaitUntilFinished
// Создаём операцию, которая работает в каком-то одном потоке, и с помощью WaitUntilFinished блокируем весь поток, пока не выполнятся все операции
// Барьер, который ждёт, пока все "бегуны" не добегут до финиша, а потом запускает следующих "бегунов" (где бегуны - таски)
class WaitOperationTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        operationQueue.addOperation {
            sleep(1)
            print("Test 1")
        }
        operationQueue.addOperation {
            sleep(2)
            print("Test 2")
        }
        // здесь задержек нет. Этим мы спровоцируем их так, что эти operation выполнились быстрее, чем 1 и 2-ая
        // И, конечно же, они выполнятся первее, чем 1 и 2. Но представим ситуацию, в которой нам нужно, чтобы сначала выполнились 1 и 2
        // Допустим, ждём картинку из интернета. Опять затрагиваем тему синхронизации потоков
        operationQueue.waitUntilAllOperationsAreFinished()
        
        operationQueue.addOperation {
            print("Test 3")
        }
        operationQueue.addOperation {
            print("Test 4")
        }
        
        operationQueue.waitUntilAllOperationsAreFinished() // чтобы разделитель (2) отображался нормально, а так этой строчки кода нет (что видно по тому, что в waitUntilFinished в последнем addOperations в WaitOperationTest2 значение false
    }
}

func waitOperationTestMethod() {
    let waitOperationTest = WaitOperationTest()
    waitOperationTest.test()
    print("---") // (2)
    let waitOperationTest2 = WaitOperationTest2()
    waitOperationTest2.test()
}

class WaitOperationTest2 {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("Test 1")
        }
        let operation2 = BlockOperation {
            sleep(2)
            print("Test 2")
        }
        
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
        
        let operation3 = BlockOperation {
            print("Test 3")
        }
        let operation4 = BlockOperation {
            print("Test 4")
        }
        operationQueue.addOperations([operation3, operation4], waitUntilFinished: false)
    }
}

// CompletionBlock
// Выполняется что-то, потом completion block. Точно так же есть операция, и у неё комплишн блок. Например: получаем данные, потом выводим анимацию
func completionBlockTestMethod() {
    let completionBlockTest = CompletionBlockTest()
    completionBlockTest.test()
}

class CompletionBlockTest {
    private let operationQueue = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(3) // всё равно Finish выполнится после
            print("Test CompletionBlock 1")
        }
        operation1.completionBlock = {
            print("Finish CompletionBlock 1")
        }
        operationQueue.addOperation(operation1)
    }
}
