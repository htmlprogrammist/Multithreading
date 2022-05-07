//
//  AsyncAfter+ConcurrentPlatform.swift
//  multithreading
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import Foundation

func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> ()) {
    queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
        completion()
    }
}
