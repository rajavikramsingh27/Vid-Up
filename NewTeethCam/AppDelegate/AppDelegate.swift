//
//  AppDelegate.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import CoreData

import FacebookCore
import FBSDKCoreKit
import SVProgressHUD

import GoogleSignIn
import Google


import LinkedinSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hud: SVProgressHUD?

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
//    MARK - Google API
    
    GIDSignIn.sharedInstance().clientID = "687354982214-fp9qvmd3celrc4t7fa77cipqsi545c89.apps.googleusercontent.com"
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
    
    
        if let data_LoginData = UserDefaults.standard.object(forKey: k_LOGIN_DATA) as? Data {
            let dict_LoginData = NSKeyedUnarchiver.unarchiveObject(with: data_LoginData) as! [String: Any]
            
            Model_Login.sharedInstance.dict_LoginData = dict_LoginData
            
            Model_Login.sharedInstance.str_User_ID = "\(dict_LoginData["UserId"]!)"
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            let navigationController = UINavigationController.init(rootViewController: viewController)
            navigationController.navigationBar.barTintColor = UIColor (red: 234.0/255.0, green: 68.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
    
        FBSDKApplicationDelegate .sharedInstance() .application(application, didFinishLaunchingWithOptions: launchOptions)
    
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEventsLogger.activate(application)
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }


//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
//    {
//        
//        let facebookDidHandle:Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)
//
//        return facebookDidHandle
//    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NewTeethCam")
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

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: sourceApplication,
//                                                 annotation: annotation)
//    }
//
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
//        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: sourceApplication,
//                                                 annotation: annotation)
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return LISDKCallbackHandler .application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//    }
    
//    func application(application: UIApplication,
//                     openURL url: NSURL,
//                     sourceApplication: String?,
//                     annotation: AnyObject) -> Bool {

        // Linkedin sdk handle redirect
//        if LinkedinSwiftHelper.shouldHandle(url as URL)  {
//            return LinkedinSwiftHelper.application(application,
//                                                   open: url as URL,
//                                                   sourceApplication: sourceApplication,
//                                                   annotation: annotation
//            )
//        }

//        return LISDKCallbackHandler .application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
//        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

        
//        return true
//    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//
//
//        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
//
//
//        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
//    }
}



extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}



