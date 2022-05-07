//
//  Operation+LifeCycle.swift
//  multithreading
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

// Operation & Operation Queue
// Operation - это абстрактный класс, предоставляющий код и данные, связанные с задачей.
// Или - это абстрактный класс, предоставляющий потокобезопасную структуру для моделирования состояния операции, её приоритета

// Operation Queue похожа на DispatchQueue - абстрактная структура данных с приоритетами
// Операционная очередь выполняет свои очереди объектов Operation на основе их приоритета и готовности.

/// # Жизненный цикл Operation
/// `isReady` говорит о том, что операция готова для выполнения (свойство выставлено в `true`). Свойство выставлено в `false`, если зависимые операции еще не выполнились. Обычно у вас нет прямой необходимости для того, чтобы переопределять это свойство. Если готовность ваших операций определяется не только через зависимые операции, вы можете предоставить свою собственную имплементацию `isReady` и определять готовность операции для выполнения самостоятельно.
/// `isExecuting` означает, что операция выполняется в данный момент. `True` если операция выполняется, `false` если нет. Если вы переопределяете метод `start`, вы также должны переопределить `isExecuting` и отправлять KVO нотификации, когда статус выполнения вашей операции изменился.
/// `isFinished` означает, что операция была успешно завершена или отменена. Пока свойство будет выставлено в `false`, операция будет находиться в operation queue. Если вы переопределяете метод `start`, вы также должны переопределить `isFinished` и отправлять KVO нотификации, когда ваша операция будет выполнена или отменена.
/// `isCancelled` означает, что запрос об отмене операции был отправлен. Поддержку отмены операции вы должны реализовать самостоятельно.

func testOperation() {
    print(Thread.current)
    
    let operation1 = {
        print("start")
        print(Thread.current)
        print("finish")
    }
    
    let queue = OperationQueue()
    queue.addOperation(operation1)
}

func testBlockOperation() {
    print(Thread.current) // main
    
    var result: String?
    // этот способ немного отличный от создания operation, потому что мы работаем с классом BlockOperation, а не просто блок создаём и ни от кого не наследуемся
    let concatOperation = BlockOperation {
        result = "iOS" + " " + "Developing"
        print(Thread.current) // main (1) | null (2)
    }
    
    concatOperation.start()
    print(result!)
    // Почему main 2 раза (1)? Потому что BlockOperation, как и обычный блок, никуда не переводит. Никак асинхронно он сам себя не может отображать.
    // Для этого нам нужен Operation (см. ниже)
}

func testOperationQueue() {
    print(Thread.current) // main
    
    var result: String?
    
    let concatOperation = BlockOperation {
        result = "iOS" + " " + "Developing"
        print(Thread.current) // main (1) | null (2)
    }
    
    let queue = OperationQueue() // (2) какой-то поток, куда нас перевела OperationQueue
    queue.addOperation(concatOperation)
    sleep(2) // Unexpectedly found nil while force-unwrapping value, поэтому добавил задержку, чтобы операция успела выполниться
    print(result!)
}

class MyThread: Thread {
    override func main() {
        print("main() in MyThread")
    }
}

class OperationA: Operation {
    override func main() {
        print("main() in OperationA")
    }
}

func overridingThreadAndOperation() {
    let thread = MyThread()
    thread.start()
    
    let operation = OperationA()
//    operation.start()
    let queue1 = OperationQueue() // то же самое, что и вызов start напрямую
    queue1.addOperation(operation)
}
