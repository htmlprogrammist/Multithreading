//
//  Quality of service.swift
//  multithreading
//
//  Created by Егор Бадмаев on 11.04.2022.
//

import Foundation

// Качество обслуживания

func qosPthread() {
    var pthread = pthread_t(bitPattern: 0)
    var attribute = pthread_attr_t()
    pthread_attr_init(&attribute)
    pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_DEFAULT, 0)
    pthread_create(&pthread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
        print("Test")
        return nil
    }, nil)
}

func qosNsThread() {
    let nsThread = Thread {
        print("Test with NSThread")
        print(qos_class_self())
    }
    nsThread.qualityOfService = .userInteractive
    nsThread.start()
    
    print(qos_class_main())
}
