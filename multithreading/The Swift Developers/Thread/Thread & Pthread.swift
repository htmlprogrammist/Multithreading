//
//  Thread & Pthread.swift
//  multithreading
//
//  Created by Егор Бадмаев on 09.04.2022.
//  https://youtu.be/JtDf-S1uLLs

import Foundation

// MARK: UNIX - POSIX
// низкоуровневая многопоточность. Ниже только операционная система
func unixPosix() {
    var thread = pthread_t(bitPattern: 0) // создаём поток
    var attribute = pthread_attr_t()
    
    pthread_attr_init(&attribute)
    pthread_create(&thread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
        print("Test with POSIX")
        return nil
    }, nil)
}

// MARK: Thread
// Тут уже обёртка от Objective-C
func threadAndPthread() {
    let nsthread = Thread {
        print("Test with thread")
    }
    nsthread.start()
}
