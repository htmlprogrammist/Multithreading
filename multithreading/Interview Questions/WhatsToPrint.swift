//
//  WhatsToPrint.swift
//  multithreading
//
//  Created by Егор Бадмаев on 03.08.2022.
//

import Foundation

/**
 Что выведется в консоль первым?
 
 [GCD - Каверзные вопросы и задачи на iOS-Собеседование - Mad Brains Техно](https://youtu.be/uEeFqIUXJcE?t=24)
 
 Ответ:
 ```
 A
 F
 B
 E
 G
 C
 D
 ```
 Объяснение:
 
 */
func firstMethod() {
    print("A")
    
    DispatchQueue.main.async {
        print("B")
        
        DispatchQueue.main.async {
            print("C")
        }
        
        DispatchQueue.main.async {
            print("D")
        }
        
        DispatchQueue.global().sync {
            print("E")
        }
    }
    
    print("F")
    
    DispatchQueue.main.async {
        print("G")
    }
}

/**
 Что выведется в консоль первым?
 
 [GCD - Каверзные вопросы и задачи на iOS-Собеседование - Mad Brains Техно](https://youtu.be/uEeFqIUXJcE?t=24)
 
 Ответ:
 ```
 A
 I
 B
 H
 F
 C
 G
 D
 E
 ```
 */
func secondMethod() {
    print("A")
    
    DispatchQueue.main.async {
        print("B")
        
        DispatchQueue.main.async {
            print("C")
            
            DispatchQueue.main.async {
                print("D")
                
                DispatchQueue.main.async {
                    print("E")
                }
            }
        }
        
        DispatchQueue.global().async {
            print("F")
            
            DispatchQueue.main.async {
                print("G")
            }
        }
        
        print("H")
    }
    
    print("I")
}
