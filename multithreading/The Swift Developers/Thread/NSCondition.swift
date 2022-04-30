//
//  NSCondition.swift
//  multithreading
//
//  Created by Егор Бадмаев on 29.04.2022.
//

import Foundation

/*
 Если мы с вами создаём 2 потока, то нет никакой гарантии, что кто-то придёт в одно время, а кто-то другой в другое
 Потоки могут прийти какой-то быстрее, какой-то медленнее, в другой раз второй быстрее первого и тд
 
 Допустим у нас есть ситуация, когда нам нужно в одном потоке записать что-то в массив
 А следующий поток хочет сделать print(), но он выведет пустой массив
 
 NSCondition нам в помощь
 Если условие не выполнилось, то мы через NSCondition будем "просить его подождать"
 */

// MARK: C
func NSConditonCCode() {
    /*
     Нам не нужно, чтобы Printer сработал раньше времени, до того, как отработает Writer
     Поэтому мы ставим Printer на паузу, используя pthread_cond_wait
     */
    let printer = ConditionMutexPrinter()
    let writer = ConditionMutexWriter()
    
    printer.start()
    writer.start()
    /* Output:
     Printer enter
     writer enter
     writer exit
     Printer exit
     */
}

// 1-й поток
class ConditionMutexPrinter: Thread {
    
    var available = false
    var condition = pthread_cond_t()
    var mutex = pthread_mutex_t()
    
    override init() {
        super.init()
        
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        super.main()
        
        printer()
    }
    
    private func printer() {
        pthread_mutex_lock(&mutex) // вешаем замочек на наш поток, чтобы сторонний поток не залез в этот метод и не испортил нам данные
        
        print("Printer enter")
        
        while !available {
            pthread_cond_wait(&condition, &mutex) // говорим нашему pthread: "Ожидай (wait)"
        }
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
        
        available = false // чтобы мы могли эту функцию потом вызывать несколько раз
        
        print("Printer exit")
    }
}

// 2-й поток
class ConditionMutexWriter: Thread {
    
    var available = false
    var condition = pthread_cond_t()
    var mutex = pthread_mutex_t()
    
    override init() {
        super.init()
        
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        super.main()
        
        writer()
    }
    
    private func writer() {
        pthread_mutex_lock(&mutex) // вешаем замочек на наш поток, чтобы сторонний поток не залез в этот метод и не испортил нам данные
        
        print("writer enter")
        available = true
        
        pthread_cond_signal(&condition)
        
        defer {
            pthread_mutex_unlock(&mutex)
        }
        
        print("writer exit")
    }
}

// MARK: Swift
func NSConditionSwiftCode() {
    let printer = PrinterThread()
    let writer = WriterThread()
    
    printer.main()
    writer.main()
    /*
     Если вдруг printer приедет первый, то у нас:
     1. Блокируется поток
     2. Проверяем, если мы здесь ещё не были, то "подождём"
     3. Делаем какие-то свои дела
     4. Выходим отсюда
     5. После того, как один из потоков "засыпает" (ждёт), то мы делаем всё, что надо...
     6. ... посылаем сигнал, что всё готово, проснись (типо будильник)
     */
    // Если их поменять местами:
    writer.main()
    printer.main()
    // то ничего такого не произойдёт, то же самое, только ждать принтер уже не будет, т.к. всё выполнится ДО
    /* Output:
     Writer enter
     Writer exit
     Printer enter
     Printer exit
     */
}

// общее условие и предикат для двух потоков
let condition = NSCondition()
var available = false // predicate

class WriterThread: Thread {
    
    override func main() {
        super.main()
        
        condition.lock() // блокируем этот поток
        print("Writer enter")
        available = true
        condition.signal() // (6)
        condition.unlock()
        print("Writer exit")
    }
}

class PrinterThread: Thread {
    
    override func main() {
        super.main()
        
        condition.lock() // блокируем и этот поток (1)
        print("Printer enter")
        
        while !available { // (2)
            condition.wait()
        }
        
        // Какие-то свои дела делаем (3)
        available = false
        
        condition.unlock() // (4)
        print("Printer exit")
    }
}

