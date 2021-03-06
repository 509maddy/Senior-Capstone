//
//  AppDelegate.swift
//  Senior Capstone
//
//  Created by Madison Lucas on 9/2/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

/**
 * This is the first thing to get launched when the app restarts (i.e. actually close app rather than resuming session).
 * This is where we would need to check to see if this is the user's first time opening the application and preload data,
 * or if this is not their first time and we need to initilize DailyState.swift, which I am thinking will hold their targets and
 * other personal settings.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()
        ThemeManager.applyTheme(theme: .coolBlue)
        
        UNUserNotificationCenter.current().delegate = self
        
        // request permission from user to send notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
          if authorized {
            DispatchQueue.main.async(execute: {
                application.registerForRemoteNotifications()
            })
          }
        })

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
    }

    private func preloadData() {
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: preloadedDataKey) == false {
            userDefaults.set(true, forKey:preloadedDataKey)
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Senior_Capstone")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Gets permisision to send notifications and then schedules the notification
    func registerForPushNotifications(){
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                self.scheduleDinnerNotification()
        }
    }
    
    
    func scheduleDinnerNotification() {
        // Notification Center
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // Data for the notification
        let content = UNMutableNotificationContent()
        content.title = "It's time for dinner!"
        content.body = "See how you can complete your goals."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        // What time the notification should be sent at
        var dateComponents = DateComponents()
        dateComponents.hour = 18 //18 = 6pm
        dateComponents.minute = 0
        
        // Schedule the notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // instantiate the view controller we want to show from storyboard
        // root view controller is tab bar controller
        // the selected tab is a navigation controller
        // then we push the new view controller to it
        
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


