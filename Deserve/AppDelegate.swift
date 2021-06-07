//
//  AppDelegate.swift
//  Deserve
//
//  Created by Ashish Khobragade on 07/06/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let imageCache = NSCache<NSString, UIImage>()
    
    lazy var downloadQueue: OperationQueue = {
      var queue = OperationQueue()
      queue.name = "Download Image queue"
      queue.maxConcurrentOperationCount = 1
      return queue
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

}

