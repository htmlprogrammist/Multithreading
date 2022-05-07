//
//  AppDelegate.swift
//  Multithreading-iOS
//
//  Created by Егор Бадмаев on 07.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        
        /// 9 - GCD Async After, Concurrent Perform, Initially Inactive
//        let vc = FirstViewController()
        
        /// 10 - GCD DispatchWorkItem, notify
//        let vc = EifelTowerViewController()
        
        /// 11 - GCD Semaphore
//        semaphoreTest1()
//        semaphoreTest2()
        /*let semaphoreTest = SemaphoreTest()
        semaphoreTest.startAllThread()*/
        
        /// 12 - GCD Dispatch Group
//        let dispatchGroupTest1 = DispatchGroupTest1()
//        dispatchGroupTest1.loadInfo()
//        let dispatchGroupTest2 = DispatchGroupTest2()
//        dispatchGroupTest2.loadInfo()
//        let vc = DispatchGroupViewController()
        
        /// 13 - GCD Dispatch Barrier
//        raceConditionInBarrier()
//        testBarrier()
        
        /// 14 - GCD Dispatch Source
//        dispatchSourceTest()
        
        /// 15 - Operation & OperationQueue & OperationBlock
//        testOperation()
//        testBlockOperation()
//        testOperationQueue()
//        overridingThreadAndOperation()
        /// 16 - BlockOperation & WaitUntilFinished & OperationCancel
//        cancelOperationMethod() // Отмена операции
//        waitOperationTestMethod() // WaitUntil
//        completionBlockTestMethod() // CompletionBlock
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
