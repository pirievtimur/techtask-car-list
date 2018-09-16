//
//  AppDelegate.swift
//  car-list
//
//  Created by Timur Piriev on 9/16/18.
//  Copyright © 2018 Timur Piriev. All rights reserved.
//

import UIKit
import CoreData
import AppSpectorSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = AppSpectorConfig(apiKey: "ZWU3MWE3YjktMjU4Mi00NmFkLWI5YzEtNDAzZDA2MDQ2YmJm", monitorIDs: [Monitor.coredata])
        AppSpector.run(with: config)
        
        return true
    }
}

