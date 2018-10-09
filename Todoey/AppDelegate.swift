//
//  AppDelegate.swift
//  Todoey
//
//  Created by 67621177 on 13/09/2018.
//  Copyright © 2018 67621177. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // This happen before any viewcontroller is laded
        //print path where userDebaults lives
        
        //print where Realm db is stored
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    
        //realms are like ersistent containers
        do{
            _ = try Realm()
        }catch{
            print("Error initialiting realm \(error)")
        }
        return true
    }





}

